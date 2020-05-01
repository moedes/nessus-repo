 #This Script aims to install the Tenable Nessus Agent on Windows Hosts and link to the Tenable instance with being added to the
#appropriate groups in Tenable.
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    $action,

    [Parameter(Mandatory=$false)]    
    [string] $installfilepath,
        
    [Parameter(Mandatory=$false)]
    [string] $key,

    [Parameter(Mandatory=$false)]
    [string] $groups
)

function Nessus-Install {
    [CmdletBinding()]

    param (
    
      [Parameter(Mandatory=$true)]    
      [string] $installfilepath
         
    )
        
    #Arguements for installation of the agent

    $installargs = "/i " + $installfilepath + " /qn"

    #Install Agent
    start-process -filepath "msiexec"  -ArgumentList $installargs -PassThru -Wait
}

function Nessus-Link {
    [CmdletBinding()]

    param (
    
      [Parameter(Mandatory=$true)]    
      [string] $key

    )

    #Arguements for linking the agent
    $connectargs =  "agent link --cloud --key=" + $key + " --groups=""${groups}"""

    #Link Agent
    start-process -filepath "c:\program files\tenable\nessus agent\nessuscli.exe" -ArgumentList $connectargs -PassThru -Wait

    # $delfile = if (Test-Path -LiteralPath $installfilepath) {Remove-Item $installfilepath}
}

function Nessus-Unlink {
    [CmdletBinding()]
    
    #Arguements for linking the agent
    $connectargs =  "agent unlink"
    
    #Unlink Agent
    start-process -filepath "c:\program files\tenable\nessus agent\nessuscli.exe" -ArgumentList $connectargs -PassThru -Wait
}

if ($action -eq "install") {
    Nessus-Install -installfilepath $installfilepath
    Nessus-Link -key $key
} elseif ($action -eq "unlink") {
    Nessus-Unlink
} elseif ($action -eq "link") {
    Nessus-Link -key $key
} else {
    Write-Host "Invalid action!  Please use install, link, or unlink for action"
}
