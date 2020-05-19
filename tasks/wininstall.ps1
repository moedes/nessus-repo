#This Script aims to install the Tenable Nessus Agent on Windows Hosts and link to the Tenable instance with being added to the
#appropriate groups in Tenable.

#Script input parameters

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

# Function to install the Nessus Agent from a designated install path

function Nessus-Install {
    [CmdletBinding()]
    
    # Requires the installpath parameter be defined

    param (
    
      [Parameter(Mandatory=$true)]    
      [string] $installfilepath
         
    )
        
    #Arguements for installation of the agent

    $installargs = "/i " + $installfilepath + " /qn"

    #Install Agent
    start-process -filepath "msiexec"  -ArgumentList $installargs -PassThru -Wait
}

# Link the Nessus Agent to the Tenable.io cloud and assign to a group in the cloud

function Nessus-Link {
    [CmdletBinding()]

    # Requires the key parameter be defined
    
    param (
    
      [Parameter(Mandatory=$true)]    
      [string] $key,

      [Parameter(Mandatory=$true)]
      [string] $groups

    )

    #Arguements for linking the agent
    $connectargs =  "agent link --cloud --key=" + $key + " --groups=""${groups}"""

    #Link Agent
    start-process -filepath "c:\program files\tenable\nessus agent\nessuscli.exe" -ArgumentList $connectargs -PassThru -Wait

    # $delfile = if (Test-Path -LiteralPath $installfilepath) {Remove-Item $installfilepath}
}

# Function to unlink the Nessus Agent if required, no parameters required

function Nessus-Unlink {
    [CmdletBinding()]
    
    #Arguements for linking the agent
    $connectargs =  "agent unlink"
    
    #Unlink Agent
    start-process -filepath "c:\program files\tenable\nessus agent\nessuscli.exe" -ArgumentList $connectargs -Wait
}

# Logic to install and link, unlink, or link the nessus agent

if ($action -eq "install") {
    Nessus-Install -installfilepath $installfilepath # Install Nessus Agent
    Nessus-Link -key $key -groups $groups            # Link Nessus Agent
} elseif ($action -eq "unlink") {
    Nessus-Unlink                                    # Unlink Nessus Agent
} elseif ($action -eq "link") {
    Nessus-Link -key $key -groups $groups            # Link Nessus Agent
} else {
    Write-Host "Invalid action!  Please use install, link, or unlink for action"
}
