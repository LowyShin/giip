# powershell .\httpcheck.ps1 -targetUrl "https://github.com/LowyShin/KnowledgeBase"

param (
    [string]$targetUrl,
    [int]$maxLinks = 100,     # 最大リンク数の制限
    [int]$timeoutSec = 10,    # 各リクエストのタイムアウト（秒）
    [int]$delayMs = 500       # リクエスト間の遅延（ミリ秒）
)

if (-not $targetUrl) {
    Write-Host "Error: ターゲットURLを指定してください。例: .\script.ps1 -targetUrl 'https://example.com'"
    exit
}

$domainName = ([uri]$targetUrl).Host
$date = Get-Date -Format "yyyyMMdd"
$scriptPath = Get-Location
$evidenceFolder = Join-Path -Path $scriptPath -ChildPath "evidence"
if (!(Test-Path -Path $evidenceFolder)) { New-Item -ItemType Directory -Path $evidenceFolder | Out-Null }
$outputCsvPath = Join-Path -Path $evidenceFolder -ChildPath "${domainName}_404Errors_$date.csv"

$brokenLinks = @()

function Test-Url {
    param (
        [string]$url,
        [int]$timeoutSec
    )
    try {
        $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec $timeoutSec -ErrorAction Stop
        return $true
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) { return $false }
        return $true
    }
}

function Check-Links {
    param (
        [string]$url,
        [int]$maxLinks,
        [int]$timeoutSec,
        [int]$delayMs
    )

    try {
        Write-Host "Get Content from $url"
        $content = Invoke-WebRequest -Uri $url -ErrorAction Stop
        Write-Host "Find Links..."
        $links = $content.Links | Where-Object { $_.href -match "^/|https?://$($content.BaseResponse.ResponseUri.Host)" }
        $links = $links | Select-Object -First $maxLinks

        Write-Host "Get links done..."
        Write-Host "$links"

        foreach ($link in $links) {
            $linkUrl = if ($link.href -match "^/") { "$($content.BaseResponse.ResponseUri.Scheme)://$($content.BaseResponse.ResponseUri.Host)$($link.href)" } else { $link.href }
            
            Write-Host "Retrieve to $link"
            if (-not (Test-Url -url $linkUrl -timeoutSec $timeoutSec)) {
                $brokenLinks += [pscustomobject]@{ URL = $linkUrl; Status = "404 Not Found" }
            }
            Start-Sleep -Milliseconds $delayMs
        }
    } catch {
        Write-Host "Failed to retrieve $url"
    }
}

Check-Links -url $targetUrl -maxLinks $maxLinks -timeoutSec $timeoutSec -delayMs $delayMs

if ($brokenLinks.Count -gt 0) {
    $brokenLinks | Export-Csv -Path $outputCsvPath -NoTypeInformation -Encoding UTF8
    Write-Host "404エラーのリンクが $outputCsvPath に保存されました。"
} else {
    Write-Host "404リンクは見つかりませんでした。"
}
