# giip pwershell script
# Written by Lowy at 170702
# Uninatall target program

# User Variables
# You can put part of name. but check other same name of program important
$SWName = "VMWare"
$factor = "Uninstall_History"

# giip Variables 
# Don't change belows if you don't know.
$sk = "{{sk}}"
$lssn = "{{lssn}}"
$type = "lssn"

# giip functions
function giipKVSPut($sk, $type, $lssn, $factor, $valueJson) {
    $qs = "sk=$sk&type=$type&key=$lsSn&factor=$factor&value=$valueJson"
    $lwURL = "http://giip.littleworld.net/API/kvs/kvsput.asp"
    echo $qs
    Invoke-RestMethod -Uri $lwURL -Method POST -Body $qs
}

# System Script
$regdate = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
$uninstall32 = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "$SWName" } | select UninstallString
$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "$SWName" } | select UninstallString
"Selected softwares..."
$uninstall32
$uninstall64

if ($uninstall64) {
    $UnInstallCmd = $uninstall64 = $uninstall64.UninstallString
    Write "Uninstalling x64..."
    if ($UnInstallCmd -match "uninstall.exe"){
        $uninstall64 = $uninstall64.Trim()
        $uninstall64
        Write "uninstall.exe"
        start-process "$uninstall64"
        $valueJson = "{""Software Name"":""$valueJson"", ""datetime"":""$regdate""}"
        giipKVSPut $sk $type $lssn $factor $valueJson
    }else{
        $uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
        $uninstall64 = $uninstall64.Trim()
        $uninstall64
        Write "msiexec.exe"
        start-process "msiexec.exe" -arg "/X $uninstall64 /quiet /passive /qn /norestart"
        $valueJson = "{""Software Name"":""$valueJson"", ""datetime"":""$regdate""}"
        giipKVSPut $sk $type $lssn $factor $valueJson
    }
}
if ($uninstall32) {
    $UnInstallCmd = $uninstall64 = $uninstall64.UninstallString
    Write "Uninstalling x32..."
    if ($UnInstallCmd -match "uninstall.exe"){
        $uninstall32 = $uninstall32.Trim()
        $uninstall32
        Write "uninstall.exe"
        start-process "$uninstall32"
        $valueJson = "{""Software Name"":""$valueJson"", ""datetime"":""$regdate""}"
        giipKVSPut $sk $type $lssn $factor $valueJson
    }else{
        $uninstall32 = $uninstall32.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
        $uninstall32 = $uninstall32.Trim()
        $uninstall32
        Write "msiexec.exe"
        start-process "msiexec.exe" -arg "/X $uninstall64 /quiet /passive /qn /norestart"
        $valueJson = "{""Software Name"":""$valueJson"", ""datetime"":""$regdate""}"
        giipKVSPut $sk $type $lssn $factor $valueJson
    }
}
