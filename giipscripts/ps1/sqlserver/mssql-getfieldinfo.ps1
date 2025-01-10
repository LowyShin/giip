# 접속한 서버의 모든 데이터베이스와 테이블에 있는 field를 모두 찾아 타입과 사이즈를 CSV로 기록
# SvrList라는 변수에 서버목록을 json으로 저장하면 해당하는 모든 서버에 접속해서 서버별로 필드를 찾아 기록
# dbre_tool_conf.json에 접속정보를 저장. (서버마다 동일 ID/PW라는 전제)

param (
    [string]$SvrList  # Path to a JSON file containing the list of server names
)

# Load the SQL Server module
Import-Module -Name SqlServer -ErrorAction Stop

try {
    # Read configuration from dbre_tool_conf.json
    $configPath = Join-Path -Path (Get-Location).Path -ChildPath "dbre_tool_conf.json"
    if (-not (Test-Path -Path $configPath)) {
        throw "Configuration file dbre_tool_conf.json not found."
    }
    $config = Get-Content -Path $configPath | ConvertFrom-Json

    # Read server names from the provided JSON file
    $servers = (Get-Content -Path $SvrList | ConvertFrom-Json).Servers

    # Determine the current script directory and ensure the evidence folder exists
    $currentDir = (Get-Location).Path
    $evidenceDir = Join-Path -Path $currentDir -ChildPath "evidence"

    if (-not (Test-Path -Path $evidenceDir)) {
        New-Item -ItemType Directory -Path $evidenceDir | Out-Null
    }

    # Retrieve the common connection string from the config file
    $commonConnectionString = $config.CommonConnectionString

    foreach ($server in $servers) {
        Write-Host "Processing server: $server"

        # Replace the server placeholder in the connection string with the actual server name
        $connectionString = $commonConnectionString -replace "{ServerName}", $server

        # Append SSL options to ignore SSL warnings
        $connectionString += ";TrustServerCertificate=True;Encrypt=True"

        # Create a separate output CSV file for each server
        $serverOutputFile = Join-Path -Path $evidenceDir -ChildPath "${server}_fields.csv"
        $csvData = @()

        # Retrieve all user databases for the server (exclude system databases)
        $databases = Invoke-Sqlcmd -ConnectionString $connectionString -Query "SELECT name FROM sys.databases WHERE state_desc = 'ONLINE' AND name NOT IN ('master', 'tempdb', 'model', 'msdb')"

        foreach ($db in $databases) {
            $dbName = $db.name
            Write-Host "  Processing database: $dbName"

            # Switch context to the current database and retrieve relevant field information
            $query = @"
                USE [$dbName];
                SELECT
                    DB_NAME() AS DatabaseName,
                    t.TABLE_NAME,
                    c.COLUMN_NAME,
                    c.DATA_TYPE,
                    ISNULL(c.CHARACTER_MAXIMUM_LENGTH, 0) AS CHARACTER_MAXIMUM_LENGTH
                FROM
                    INFORMATION_SCHEMA.TABLES t
                INNER JOIN
                    INFORMATION_SCHEMA.COLUMNS c
                ON
                    t.TABLE_NAME = c.TABLE_NAME
                WHERE
                    t.TABLE_TYPE = 'BASE TABLE'
                ORDER BY
                    t.TABLE_NAME, c.COLUMN_NAME
"@

            $fields = Invoke-Sqlcmd -ConnectionString $connectionString -Query $query

            foreach ($field in $fields) {
                $tableName = $field.TABLE_NAME
                $fieldName = $field.COLUMN_NAME
                $dataType = $field.DATA_TYPE
                $maxLength = [int]$field.CHARACTER_MAXIMUM_LENGTH

                # Add relevant fields to the CSV data
                $csvData += [PSCustomObject]@{
                    Server = $server
                    Database = $dbName
                    Table = $tableName
                    Field = $fieldName
                    DataType = $dataType
                    MaxLength = $maxLength
                }
            }
        }

        # Export the data to CSV
        $csvData | Export-Csv -Path $serverOutputFile -NoTypeInformation -Force
    }

    Write-Host "Field extraction complete. Results saved to $evidenceDir"

} catch {
    Write-Error "An error occurred: $_"
}
