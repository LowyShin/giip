# Install-Module -Name Selenium -Scope CurrentUser

# powershell .\httpcheck.ps1 -targetUrl "https://github.com/LowyShin/KnowledgeBase/blob/master/README.md"
# powershell .\httpcheck.ps1 -targetUrl "https://giipasp.azurewebsites.net/view/BASIX/index.asp"
# powershell .\httpcheck.ps1 -targetUrl "https://giipasp.azurewebsites.net/view/BASIX/BSX-link.asp"

param (
    [string]$targetUrl,
    [int]$maxLinks = 100,     # Maximum number of links to check
    [int]$timeoutSec = 10,    # Timeout for each request in seconds
    [int]$delayMs = 500       # Delay between requests in milliseconds
)

# Selenium モジュールのインポート
Import-Module Selenium

# ChromeDriverのパスとオプション設定
$chromeDriverPath = "C:\Drivers\chromedriver-win64"  # ChromeDriverのフルパス
$options = New-Object OpenQA.Selenium.Chrome.ChromeOptions
$options.BinaryLocation = "C:\Program Files\Google\Chrome\Application\chrome.exe"  # Chromeのバイナリパス

# ChromeDriverサービスを開始
$service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($chromeDriverPath)
$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($service, $options)

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

# 排除したいURLのパターンをリスト化
$excludePatterns = @(
    "/ads",             
    "/tracking",        
    "/KnowledgeBase/issues",
    "/KnowledgeBase/pulls",
    "/actions",
    "/KnowledgeBase/projects",
    "/KnowledgeBase/security",
    "/KnowledgeBase/pulse",
    "/github.com/collections",
    "/github.com/customer-stories",
    "/github.com/enterprise",
    "/github.com/features",
    "/github.com/login",
    "/github.com/premium-support",
    "/github.com/pricing",
    "/github.com/resources",
    "/github.com/readme",
    "/github.com/security",
    "/github.com/solutions",
    "/github.com/sponsors",
    "/github.com/team",
    "/github.com/topics",
    "/github.com/trending",
    "KnowledgeBaseHome/wiki",
    "https://example.com/unwanted-path"
)

# URLにアクセス
Write-Host "Get Content from $targetUrl"
$driver.Navigate().GoToUrl($targetUrl)

# リンクを取得
Write-Host "Find Links..."
$links = $driver.FindElementsByTagName("a") | Select-Object -First $maxLinks | ForEach-Object {
    $_.GetAttribute("href")
}
# Write-Host "$links"

# 各リンクのチェック
foreach ($link in $links) {
    Write-Host "Check URL : $link"
    $matchedPattern = $excludePatterns | Where-Object { $link -like "*$_*" }

    if ($link -and $matchedPattern) {
        # リンクが除外パターンに一致する場合、どのパターンに一致したかを表示
        Write-Host "URL '$link' is matched exclude pattern: $matchedPattern"
    } else {
        try {
            $response = Invoke-WebRequest -Uri $link -Method Head -TimeoutSec $timeoutSec -ErrorAction Stop
            Start-Sleep -Milliseconds $delayMs
        } catch {
            if ($_.Exception.Response.StatusCode -eq 404) {
                $brokenLinks += [pscustomobject]@{ URL = $link; Status = "404 Not Found" }
                Write-Host "Failed...."
            }
        }
    }
}

# 結果をCSVに保存
if ($brokenLinks.Count -gt 0) {
    $brokenLinks | Export-Csv -Path $outputCsvPath -NoTypeInformation -Encoding UTF8
    Write-Host "404エラーのリンクが $outputCsvPath に保存されました。"
} else {
    Write-Host "404リンクは見つかりませんでした。"
}

# WebDriverを終了
$driver.Quit()
