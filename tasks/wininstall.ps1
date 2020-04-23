param ($installfilepath,$key)

#Arguements for installation of the agent

$installargs = "/i " + $installfilepath + " /qn"

#Install Agent
start-process -filepath "msiexec"  -ArgumentList $installargs -Wait

#Arguements for linking the agent
$connectargs =  "agent link --cloud --key=" + $key 

#Link Agent
start-process -filepath "c:\program files\tenable\nessus agent\nessuscli.exe" -ArgumentList $connectargs -Wait

$delfile = if (Test-Path -LiteralPath $installfilepath) {Remove-Item $installfilepath}


