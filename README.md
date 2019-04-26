# pwsh-GC
A collection of Powershell Core modules and scripts for GuardiCore Centra administration and management.

## What is this?
The pwsh-GC module is essentially a wrapper for GuardiCore's management server API. It also contains functions that help in using the API, such as ConvertTo/ConvertFrom-GCUnixTime, Get-GCFlowTotal, etc. The other scripts in this repository are used when working with data from the API. The module is written in PowerShell Core (PS 6.x); you will need to install PowerShell Core in order to use this module.

## Installation
Install PowerShell Core from the PowerShell github repository, here:\
https://github.com/powershell/powershell \
Then download/clone the repository, and import the module:
```PowerShell
Import-Module ./pwsh-GC.psd1.
```

## Use
Either use/write scripts that utilize the functions, or use them directly from the command line.

### Authentication
After you import the module, authenticate with the server **(Note: 2-factor authentication cannot be enabled)**:
```PowerShell
Get-GCApiKey -Server "cus-XXXX" -Credentials $Creds
```
where $Creds is a PowerShell credential object (you can call Get-Credential). Alternatively, just supply a username, and it will prompt for your password.

This function saves the api token to a global variable called $GCApiKey that is used automatically by the rest of the functions in the module; there's no need to store it and manually enter it each time. It works like a typical GuardiCore user session, with the same timeout value (24 hours by default). **Note: exiting the PowerShell session will require that you re-authenticate.**

### Examples
Create a static label from an array of hostnames:

```PowerShell
$Hostnames = @(
  "Example-DC",
  "Example-WSUS",
  "Example-Web"
)
$Assets = foreach ($VM in $Hostnames) {
  Get-GCAsset -Search $VM
}
$Assets | New-GCStaticLabel -LabelKey "Example" -LabelValue "Demo"
```
returns:
```PowerShell
id                                   name          key     value
--                                   ----          ---     -----
XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX Example: Demo Example Demo
```
