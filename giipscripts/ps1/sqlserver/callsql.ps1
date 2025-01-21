# Parameter setup
param (
    [string]$SqlFileName = "GetTableSizes.sql"  # Default SQL file name
)

# JSON file paths
$ServerListJson = ".\ServerList.json"
# for testing 
$ServerListJson = ".\ServerList.json"
$ConnectionConfJson = ".\dbre_tool_conf.json"

# Script directory and file paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SqlFilePath = Join-Path -Path $ScriptDir -ChildPath "sql\$SqlFileName"
$EvidenceDir = Join-Path -Path $ScriptDir -ChildPath "evidence"

# Check and create output directory
if (!(Test-Path -Path $EvidenceDir)) {
    New-Item -ItemType Directory -Path $EvidenceDir | Out-Null
}

# Validate JSON files
if (!(Test-Path -Path $ServerListJson)) {
    Write-Error "Server list JSON file not found: $ServerListJson"
    exit 1
}
if (!(Test-Path -Path $ConnectionConfJson)) {
    Write-Error "Connection configuration JSON file not found: $ConnectionConfJson"
    exit 1
}

# Validate SQL file
if (!(Test-Path -Path $SqlFilePath)) {
    Write-Error "Specified SQL file not found: $SqlFilePath"
    exit 1
}

# Read JSON files
$ServerList = (Get-Content -Path $ServerListJson | ConvertFrom-Json).Servers
$ConnectionConf = Get-Content -Path $ConnectionConfJson | ConvertFrom-Json

# Execute SQL for each server
foreach ($Server in $ServerList) {
    try {
        Write-Host "Connecting to server: $Server"

        # Replace server name in the connection string
        $ConnectionString = $ConnectionConf.CommonConnectionString -replace "{ServerName}", $Server

        # Create output file path
        $OutputCsvPath = Join-Path -Path $EvidenceDir -ChildPath "$Server-TableSizes.csv"

        # Execute SQL and export results to CSV
        Invoke-Sqlcmd -ConnectionString $ConnectionString -InputFile $SqlFilePath -QueryTimeout 120 |
        Export-Csv -Path $OutputCsvPath -NoTypeInformation -Encoding UTF8

        Write-Host "Data for server $Server has been saved to $OutputCsvPath."

    } catch {
        Write-Error "An error occurred while connecting to server `${Server}`: $($_)"
    }

}

Write-Host "All processes have been completed."
