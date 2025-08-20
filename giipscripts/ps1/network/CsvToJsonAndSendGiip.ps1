<#
.SYNOPSIS
  지정된 CSV 파일을 읽어 JSON으로 변환 후 giipapi로 전송
.DESCRIPTION
  - CSV 파일을 읽어 JSON으로 변환
  - KVSConfig.json에서 giipapi 전송 설정 로드
.PARAMETER CsvFile
  변환할 CSV 파일 경로
.PARAMETER Output
  결과 JSON 파일 경로(옵션)
.PARAMETER SendToGiip
  giipapi로 전송 여부
.PARAMETER KVSConfigPath
  giipapi 설정 JSON 경로(옵션, 기본값: KVSConfig.json)
.EXAMPLE
  .\CsvToJsonAndSendGiip.ps1 -CsvFile .\data.csv -SendToGiip
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$CsvFile,
  [string]$Output = "./csv_result.json",
  [switch]$SendToGiip,
  [string]$KVSConfigPath = "./KVSConfig.json"
)

# CSV 파일 로드
if (!(Test-Path $CsvFile)) { throw "CSV 파일이 없습니다: $CsvFile" }
$csv = Import-Csv $CsvFile
$csv | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $Output

# giipapi 설정 로드 및 전송
if ($SendToGiip) {
  if (!(Test-Path $KVSConfigPath)) { throw "KVSConfig 파일이 없습니다: $KVSConfigPath" }
  $kvs = Get-Content $KVSConfigPath -Raw | ConvertFrom-Json
  # CSV 파일명에서 확장자 제거하여 kFactor로 사용
  $csvBaseName = [System.IO.Path]::GetFileNameWithoutExtension($CsvFile)
  $body = @{
    kType = $kvs.KType
    kKey = $kvs.KKey
    kFactor = $csvBaseName
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
