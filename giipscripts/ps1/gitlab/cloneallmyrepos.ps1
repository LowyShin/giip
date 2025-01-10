# 20250110 Lowy Shin 
# 내가 볼 수 있는 전체 레포지터리를 클론하는 스크립트. 

# GitLab Personal Access Token 설정
$token = ""  # Personal Access Token (my페이지에 access token 메뉴가 있음.)
$gitlabUrl = "https://gitlab.com/"      # GitLab URL
$userId = ""       # GitLab 사용자 이름

# 스크립트 실행 디렉토리를 기준으로 OutputFolder 설정
$outputFolder = (Get-Location).Path

# API 호출을 위한 헤더 설정
$headers = @{
    "PRIVATE-TOKEN" = $token
}

# 저장소 리스트 가져오기
Write-Host "Fetching repositories for user $userId..."
$projectsUrl = "$gitlabUrl/api/v4/projects?membership=true&per_page=100"
$projects = Invoke-RestMethod -Uri $projectsUrl -Headers $headers -Method Get

if (-not (Test-Path -Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# 모든 저장소 클론
foreach ($project in $projects) {
    $repoName = $project.name
    $repoUrl = $project.ssh_url_to_repo

    Write-Host "Cloning repository: $repoName..."
    $repoFolder = Join-Path -Path $outputFolder -ChildPath $repoName

    if (-not (Test-Path -Path $repoFolder)) {
        git clone $repoUrl $repoFolder
    } else {
        Write-Host "Repository '$repoName' already exists. Skipping..."
    }
}

Write-Host "All repositories cloned successfully!"
