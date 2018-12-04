# GuardiCoreHelper
A collection of Powershell Core modules and scripts for GuardiCore Centra administration and management.

## What is this?
The Centra.psm1 module is a wrapper for GuardiCore's management server API. It also contains functions that help in using the API, such as ConvertTo/ConvertFrom-GCUnixTime, Get-GCConnectionCount, etc. The other scripts are used when working with data from the API. The module is written in PowerShell Core (PS 6.x).

## Installation
Install PowerShell Core from the PowerShell github repository, here:  
https://github.com/powershell/powershell  
Then download/clone my repository, and Import-Module .\Centra.psm1 in a shell or a script.

## Use
Either use/write scripts that utilize the functions, or use them directly from the command line. The scripts in the repository all assume that the module file is in the same directory, and that you haven't renamed it.
