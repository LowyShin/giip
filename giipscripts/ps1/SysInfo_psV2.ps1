# Author Lowy at 170628
# Version 1.0
# Put to giip KVS the your system information on windows by powershell 2.0 or higher

# User Variables 
# You can change user variables for your condition
$factor = "SysInfo"

# Do not change below 
# giip Variables 
# giip Service Group Secret Key
$sk = "{{sk}}"
# giip Logical Server Serial Number
$lssn = {{lssn}}

# Define convert function for powershell 2.0 
function Escape-JSONString($str){
	if ($str -eq $null) {return ""}
	$str = $str.ToString().Replace('"','\"').Replace('\','\\').Replace("`n",'\n').Replace("`r",'\r').Replace("`t",'\t')
	return $str;
}

function ConvertTo-JSON($maxDepth = 4,$forceArray = $false) {
	begin {
		$data = @()
	}
	process{
		$data += $_
	}
	
	end{
	
		if ($data.length -eq 1 -and $forceArray -eq $false) {
			$value = $data[0]
		} else {	
			$value = $data
		}

		if ($value -eq $null) {
			return "null"
		}

		

		$dataType = $value.GetType().Name
		
		switch -regex ($dataType) {
	            'String'  {
					return  "`"{0}`"" -f (Escape-JSONString $value )
				}
	            '(System\.)?DateTime'  {return  "`"{0:yyyy-MM-dd}T{0:HH:mm:ss}`"" -f $value}
	            'Int32|Double' {return  "$value"}
				'Boolean' {return  "$value".ToLower()}
	            '(System\.)?Object\[\]' { # array
					
					if ($maxDepth -le 0){return "`"$value`""}
					
					$jsonResult = ''
					foreach($elem in $value){
						#if ($elem -eq $null) {continue}
						if ($jsonResult.Length -gt 0) {$jsonResult +=', '}				
						$jsonResult += ($elem | ConvertTo-JSON -maxDepth ($maxDepth -1))
					}
					return "[" + $jsonResult + "]"
	            }
				'(System\.)?Hashtable' { # hashtable
					$jsonResult = ''
					foreach($key in $value.Keys){
						if ($jsonResult.Length -gt 0) {$jsonResult +=', '}
						$jsonResult += 
@"
	"{0}": {1}
"@ -f $key , ($value[$key] | ConvertTo-JSON -maxDepth ($maxDepth -1) )
					}
					return "{" + $jsonResult + "}"
				}
	            default { #object
					if ($maxDepth -le 0){return  "`"{0}`"" -f (Escape-JSONString $value)}
					
					return "{" +
						(($value | Get-Member -MemberType *property | % { 
@"
	"{0}": {1}
"@ -f $_.Name , ($value.($_.Name) | ConvertTo-JSON -maxDepth ($maxDepth -1) )			
					
					}) -join ', ') + "}"
	    		}
		}
	}
}

# for Multi socket CPU
function GetCPUinfo {
    param ([array]$servernames = ".")
    foreach ($servername in $servernames) {
        [array]$wmiinfo = Get-WmiObject Win32_Processor -computer $servername
        $cpu = ($wmiinfo[0].name) -replace ' +', ' '
        $description = $wmiinfo[0].description
        $cores = ( $wmiinfo | Select SocketDesignation | Measure-Object ).count
        $sockets = ( $wmiinfo | Select SocketDesignation -unique | Measure-Object ).count
        Switch ($wmiinfo[0].architecture) {
            0 { $arch = "x86" }
            1 { $arch = "MIPS" }
            2 { $arch = "Alpha" }
            3 { $arch = "PowerPC" }
            6 { $arch = "Itanium" }
            9 { $arch = "x64" }
        }
        $manfg = $wmiinfo[0].manufacturer
        $obj = New-Object Object
        $obj | Add-Member Noteproperty Servername -value $servername
        $obj | Add-Member Noteproperty CPU -value $cpu
        $obj | Add-Member Noteproperty Description -value $description
        $obj | Add-Member Noteproperty Sockets -value $sockets
        $obj | Add-Member Noteproperty Cores -value $cores
        $obj | Add-Member Noteproperty Architecture -value $arch 
        $obj | Add-Member Noteproperty Manufacturer -value $manfg
        $obj
    }
}

# CPU Info
$CPUInfo = GetCPUInfo .

# OS Info
$OSInfo = Get-WMiObject -class Win32_OperatingSystem | Select-Object Caption

# Memory Info 
$PhysicalMemory = Get-WmiObject -class CIM_PhysicalMemory | Measure-Object -Property capacity -sum | % {[math]::round(($_.sum / 1MB),2)} 

# JSON 변환
$output =@{
            'OS' = $OSInfo.Caption;
            'CPU' = $CPUInfo.CPU;
            'CPUCore' = $CPUInfo.Cores;
            'CPUProc' = $CPUInfo.Sockets;
            'Memory' = $PhysicalMemory;
          } 
$object = New-Object -TypeName PSObject -Property $output | ConvertTo-Json

$qs = "sk=$sk&type=lssn&key=$lsSn&factor=$factor&value=$object"
$lwURL = "http://giip.littleworld.net/API/kvs/kvsput.asp"
$lwURIFull = $lwURL + "?" + $qs
$lwURIFull

$WebRequest = [System.Net.WebRequest]::Create("$lwURIFull")
$WebRequest.ContentType = "application/json; charset=utf-8"
$Response = $WebRequest.GetResponse()
#$Response
