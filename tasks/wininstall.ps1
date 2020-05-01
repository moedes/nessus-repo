param (
    [Parameter(Mandatory)]
    $action
)

function Nessus-Install {
    param (
        [Parameter(Mandatory)]    
        [string]$installfilepath,
        
        [Parameter(Mandatory)]
        [string]$key
    )
    
    #Arguements for installation of the agent

    $installargs = "/i " + $installfilepath + " /qn"

    #Install Agent
    start-process -filepath "msiexec"  -ArgumentList $installargs -Wait

    #Arguements for linking the agent
    $connectargs =  "agent link --cloud --key=" + $key + " --groups='Windows Servers - Mozes'"

    #Link Agent
    start-process -filepath "c:\program files\tenable\nessus agent\nessuscli.exe" -ArgumentList $connectargs -Wait

    $delfile = if (Test-Path -LiteralPath $installfilepath) {Remove-Item $installfilepath}
}

function Nessus-Unlink {
    
    #Arguements for linking the agent
    $connectargs =  "agent unlink"
    
    #Unlink Agent
    start-process -filepath "c:\program files\tenable\nessus agent\nessuscli.exe" -ArgumentList $connectargs -Wait
}

if ($action -eq "install") {
    Nessus-Install
} elseif ($action -eq "unlink") {
    Nessus-Unlink
} else {
    Write-Host "Invalid action!  Please use install or unlink for action"
}
