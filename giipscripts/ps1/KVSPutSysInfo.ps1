# giip Variables 
$sk = "{{sk}}"
$lssn = {{lssn}}

# OS Info
$OSInfo = Get-WMiObject Win32_OperatingSystem | Select-Object Caption

# CPU Info
$CPUInfo = Get-WMiObject Win32_processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors

# Memory Info 
$PhysicalMemory = Get-WmiObject CIM_PhysicalMemory | Measure-Object -Property capacity -sum | % {[math]::round(($_.sum / 1MB),2)} 

# Convert and merge to JSON
$output =@{
            'OS' = $OSInfo.Caption;
            'CPU' = $CPUInfo.Name;
            'CPUCore' = $CPUInfo.NumberOfCores;
            'CPUProc' = $CPUInfo.NumberOfLogicalProcessors;
            'Memory' = $PhysicalMemory;
          } 
$object = New-Object -TypeName PSObject -Property $output | ConvertTo-Json

# Send to giip KVS
$qs = "sk=$sk&type=lssn&key=$lsSn&factor=SysInfo&value=$object"
$lwURL = "http://giip.littleworld.net/API/kvs/kvsput.asp"
Invoke-RestMethod -Uri $lwURL -Method POST -Body $qs
