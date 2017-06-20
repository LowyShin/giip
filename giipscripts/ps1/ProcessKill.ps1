# get process and kill
$psname = "notepad"

#{{CustomVariables}}

$lwps = Get-Process $psname -ErrorAction SilentlyContinue
if ($lwps) {
  # try gracefully first
  $lwps.CloseMainWindow()
  # kill after five seconds
  Sleep 5
  if (!$lwps.HasExited) {
    $lwps | Stop-Process -Force
  }
}


####################
# for Custom Variables in giip
# Copy below and paste to Customvariables on add queue page
####################
# get process and kill
$psname = "notepad"
