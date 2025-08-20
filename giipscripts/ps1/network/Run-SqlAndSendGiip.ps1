<#
.SYNOPSIS
  지정된 SQL 파일을 읽어 SQL Server에 쿼리 실행 후 결과를 JSON으로 giipapi로 전송
.DESCRIPTION
  - dbconn.json에서 DB 접속 정보 로드
  - 지정된 SQL 파일을 읽어 쿼리 실행
  - 결과를 JSON으로 giipapi로 전송
.PARAMETER SqlFile
  실행할 SQL 파일 경로
.PARAMETER Output
  결과 JSON 파일 경로(옵션)
.PARAMETER SendToGiip
  giipapi로 전송 여부
.PARAMETER KVSConfigPath
  giipapi 설정 JSON 경로(옵션, 기본값: KVSConfig.json)
.PARAMETER DbConnPath
  DB 접속정보 JSON 경로(옵션, 기본값: dbconn.json)
.EXAMPLE
  .\Run-SqlAndSendGiip.ps1 -SqlFile .\query.sql -SendToGiip
.NOTES
  - sqlcmd 필요 (SQL Server용)
  - PowerShell 5.1 이상 권장
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$SqlFile,
  [string]$Output = "./sql_result.json",
  [switch]$SendToGiip,
  [string]$KVSConfigPath = "./KVSConfig.json",
  [string]$DbConnPath = "./dbconn.json"
)

# DB 접속 정보 로드
if (!(Test-Path $DbConnPath)) { throw "DB 접속정보 파일이 없습니다: $DbConnPath" }
$dbconf = Get-Content $DbConnPath -Raw | ConvertFrom-Json

# SQL 파일 로드
if (!(Test-Path $SqlFile)) { throw "SQL 파일이 없습니다: $SqlFile" }
$sql = Get-Content $SqlFile -Raw

# 쿼리 실행 (sqlcmd 필요)
$tmpCsv = [System.IO.Path]::GetTempFileName() + ".csv"
$sqlcmdArgs = @(
  "-S", $dbconf.Server + "," + $dbconf.Port,
  "-d", $dbconf.Database,
  "-U", $dbconf.UserId,
  "-P", $dbconf.Password,
  "-Q", $sql,
  "-s", ",",
  "-W",
  "-h", "-1",
  "-o", $tmpCsv
)
$sqlcmdExe = "sqlcmd"
$rc = & $sqlcmdExe @sqlcmdArgs
if ($LASTEXITCODE -ne 0) { throw "sqlcmd 실행 실패 ($LASTEXITCODE)" }

# CSV → JSON 변환
$csv = Import-Csv $tmpCsv
$csv | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $Output
Remove-Item $tmpCsv -ErrorAction SilentlyContinue

# giipapi 설정 로드
if ($SendToGiip) {
  if (!(Test-Path $KVSConfigPath)) { throw "KVSConfig 파일이 없습니다: $KVSConfigPath" }
  $kvs = Get-Content $KVSConfigPath -Raw | ConvertFrom-Json
  $body = @{
    kType = $kvs.KType
    kKey = $kvs.KKey
    kFactor = $kvs.KFactor
    usertoken = $kvs.UserToken
    user_id = $kvs.UserId
    value = Get-Content $Output -Raw
  }
  $url = $kvs.Endpoint
  if ($kvs.FunctionCode) {
    if ($url -notmatch '\\?') { $url += "?code=$($kvs.FunctionCode)" } else { $url += "&code=$($kvs.FunctionCode)" }
  }
  $resp = Invoke-RestMethod -Uri $url -Method Post -Body ($body | ConvertTo-Json -Depth 10) -ContentType 'application/json'
  Write-Host "[giipapi] 응답: $($resp | ConvertTo-Json)"
}
else {
  Write-Host "[INFO] 결과가 $Output 에 저장되었습니다."
}
