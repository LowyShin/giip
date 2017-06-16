# giip Variables 
# (giip의 Service Group 메뉴에 있는 서버에 할당한 그룹 코드)
$sk = "{{sk}}"
# 서버 번호(서버 상세 정보 위에 있음)
$lssn = {{lssn}}

# OS Info
$OSInfo = Get-WMiObject Win32_OperatingSystem | Select-Object Caption

# CPU Info
$CPUInfo = Get-WMiObject Win32_processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors

# Memory Info 
$PhysicalMemory = Get-WmiObject CIM_PhysicalMemory | Measure-Object -Property capacity -sum | % {[math]::round(($_.sum / 1MB),2)} 

# JSON 변환
$output =@{
            'OS' = $OSInfo.Caption;
            'CPU' = $CPUInfo.Name;
            'CPUCore' = $CPUInfo.NumberOfCores;
            'CPUProc' = $CPUInfo.NumberOfLogicalProcessors;
            'Memory' = $PhysicalMemory;
          } 
$object = New-Object -TypeName PSObject -Property $output | ConvertTo-Json

# giip KVS로 던지기
$qs = "sk=$sk&type=lssn&key=$lsSn&factor=SysInfo&value=$object"
$lwURL = "http://giip.littleworld.net/API/kvs/kvsput.asp"
Invoke-RestMethod -Uri $lwURL -Method POST -Body $qs
