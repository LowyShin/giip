param(
    [Parameter(Mandatory=$true)]
    [string[]]$ProcessNames
)

# 指定したプロセスを取得
$processes = Get-Process -Name $ProcessNames -ErrorAction SilentlyContinue

if ($processes) {
    # プロセスの一覧を表示
    Write-Host "以下のプロセスが見つかりました:"
    $processes | Format-Table -AutoSize

    # ユーザーに確認を求める
    $confirm = Read-Host "これらのプロセスを終了しますか？ (Y/N)"

    if ($confirm -eq 'Y' -or $confirm -eq 'y') {
        # プロセスを終了
        $processes | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Host "プロセスを終了しました。"
    } else {
        Write-Host "操作をキャンセルしました。"
    }
} else {
    Write-Host "指定したプロセスは見つかりませんでした。"
}
