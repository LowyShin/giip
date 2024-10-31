# Magic Number를 기반으로 MIME 타입을 추론하는 함수
# eg)  .\change_extension_to_fit.ps1 -directoryPath "C:\Users\lowys\Downloads\fileproc"

# 지정한 디렉토리 내 모든 파일의 MIME 타입을 추론하고 확장자 변경
param (
    [string]$directoryPath
)

if (-not (Test-Path $directoryPath -PathType Container)) {
    Write-Host "디렉토리가 존재하지 않습니다: $directoryPath"
    exit
}

function Get-MimeTypeFromMagicNumber {
    param (
        [string]$filePath
    )

    # 파일의 첫 8바이트를 읽어서 Magic Number 확인
    $fileStream = [System.IO.File]::OpenRead($filePath)
    $buffer = New-Object byte[] 8
    $fileStream.Read($buffer, 0, 8)
    $fileStream.Close()

    # Magic Number를 16진수 문자열로 변환
    $magicNumber = -join ($buffer | ForEach-Object { "{0:X2}" -f $_ })
    Write-Host "magicNumber : $magicNumber"

    # Magic Number에 따른 MIME 타입 추론
    switch ($magicNumber.Substring(0, 8)) {
        "FFD8FF"   { return "image/jpeg" }    # JPEG 파일 (첫 3바이트 확인)
        "89504E47" { return "image/png" }     # PNG 파일 (첫 4바이트 확인)
        "47494638" { return "image/gif" }     # GIF 파일 (첫 4바이트 확인)
        "25504446" { return "application/pdf" } # PDF 파일 (첫 4바이트 확인)
        "504B0304" { return "application/zip" } # ZIP 파일 (첫 4바이트 확인)
        "504B0304" { return "application/vnd.openxmlformats-officedocument.wordprocessingml.document" } # DOCX 파일
        "3C3F786D" { return "application/xml" } # XML 파일 (첫 4바이트 확인)
        "7B226"    { return "application/json" } # JSON 파일 (첫 3바이트 확인)
        default    { return "application/octet-stream" } # 알 수 없는 파일 타입
    }
}

# MIME 타입에 맞는 확장자를 반환하는 함수
function Get-ExtensionFromMimeType {
    param (
        [string]$mimeType
    )

    switch ($mimeType) {
        "image/jpeg" { return ".jpg" }
        "image/png"  { return ".png" }
        "image/gif"  { return ".gif" }
        "application/pdf" { return ".pdf" }
        "application/zip" { return ".zip" }
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" { return ".docx" }
        "application/xml" { return ".xml" }
        "application/json" { return ".json" }
        default { return "" } # 알 수 없는 MIME 타입
    }
}

# 디렉토리 내 모든 파일을 처리
Get-ChildItem -Path $directoryPath -File | ForEach-Object {
    $filePath = $_.FullName
    $mimeType = Get-MimeTypeFromMagicNumber -filePath $filePath
    $extension = Get-ExtensionFromMimeType -mimeType $mimeType

    if ($extension -ne "") {
        $newFilePath = [System.IO.Path]::ChangeExtension($filePath, $extension)
        if ($filePath -ne $newFilePath) {
            Rename-Item -Path $filePath -NewName $newFilePath
            Write-Host "Changed filename: $filePath -> $newFilePath"
        }
    } else {
        Write-Host "Can not change file by unknown MIME type: $filePath"
    }
}
