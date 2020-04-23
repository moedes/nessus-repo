# Managing Nessus Agent with Puppet Bolt

## Description

The Bolt plans and tasks in this repo will install and manage the configurations of the Nessus Agents for both Windows and CentOS targets.   The purpose is to automate the installs to quickly stand up a test environment for machines to use in the Tenable.io platform.

## Requirements

- Puppet Bolt version 2 or higher
- Destination Windows or CentOS machines for Demo or Testing
- Authentication credentials for Windows and CentOS machines
- Powershell version 3 or higher on Windows destinations
- Tenable.io account with a linking key

## Setup for use


1. To use repo module, add the module git repository to your Boltdir Puppetfile.

    mod 'nessusagent',
       :git => 'https://github.com/moedes/nessus-repo'

2. Save inventory.yaml file for the environment into the same Boltdir directory.
3. Download OS agents into the Boltdir/site-modules/nessusagent/files directory from Tenable.io download page https://www.tenable.com/downloads/nessus-agents

## Bolt Plan Use


To use the plan run `bolt plan run nessusagent::agentinstall' with a source location of the Nessus Agent file to install and a filepath for the destination of the file for download and installation.   You will need to specify the source and filepath for nix nodes, windows nodes, or both.  The parameters to use to specify these are;

### Parameters for Windows

    winsource (Optional[String]) 
        - specified as winsource=nessusagent/<file to use> 
    winfilepath (Optional[String]) 
        - specified as winfilepath="path to download to on remote host" - e.g. "c:\windows\temp\<filename>" 
    
### Parameters for Linux

    nixsource (Optional[String]) 
        - specified as nixsource=nessusagent/<file to use> 
    nixfilepath (Optional[String]) 
        - specified as nixfilepath="/path/to/download/to" - e.g. "/home/centos/<filename>"

### Required Parameters

    key (String) - specified as key=<use your Tenable linking key>

## Examples

### **Install and link on Linux targets**

```
bolt plan run nessusagent::agentinstall targets=linux nixsource=nessusagent/NessusAgent-7.6.2-es7.x86_64.rpm nixfilepath="/home/centos/NessusAgent-7.6.2-es7.x86_64.rpm" key=<use your Tenable linking key>
```

### **Install and link on Windows targets**

```
bolt plan run nessusagent::agentinstall targets=windows winsource=nessusagent/NessusAgent-7.6.1-x64.msi winfilepath="c:\windows\temp\NessusAgent-7.6.1-x64.msi" key=<use your Tenable linking key>
```

### **Install and link on both targets**

```
bolt plan run nessusagent::agentinstall targets=windows,linux winsource=nessusagent/NessusAgent-7.6.1-x64.msi winfilepath="c:\windows\temp\NessusAgent-7.6.1-x64.msi" nixsource=nessusagent/NessusAgent-7.6.2-es7.x86_64.rpm nixfilepath="/home/centos/NessusAgent-7.6.2-es7.x86_64.rpm" key=<use your Tenable linking key>
```