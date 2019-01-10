# GuardiCoreHelper
A collection of Powershell Core modules and scripts for GuardiCore Centra administration and management.

## What is this?
The Centra.psm1 module is a wrapper for GuardiCore's management server API. It also contains functions that help in using the API, such as ConvertTo/ConvertFrom-GCUnixTime, Get-GCFlowTotal, etc. The other scripts are used when working with data from the API. The module is written in PowerShell Core (PS 6.x).

## Installation
Install PowerShell Core from the PowerShell github repository, here:\
https://github.com/powershell/powershell \
Then download/clone my repository, and Import-Module ./GuardiCoreHelper.psm1.

## Use
Either use/write scripts that utilize the functions, or use them directly from the command line.

### Authentication
After you import the module, authenticate with the server **(Note: 2-factor authentication cannot be enabled)**:
```PowerShell
Get-GCApiKey -Server "cus-XXXX" -Credentials $Creds
```
where $Creds is a PowerShell credential object (you can call Get-Credential). Alternatively, just supply a username, and it will prompt for your password.

This function saves the api token to a global variable called $GCApiKey that is used automatically by the rest of the functions in the module; there's no need to store it and manually enter it each time. It works like a typical GuardiCore user session, with the same timeout value (24 hours by default). **Note: exiting the PowerShell session will require that you re-authenticate.**
