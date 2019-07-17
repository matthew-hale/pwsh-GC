[cmdletbinding()]
param (
    $Task = "Default"
)

$Modules = @(
    "pester",
    "psake",
    "platyPS",
    "PSScriptAnalyzer"
)

$ModuleInstallScope = "CurrentUser"

Install-Module -Name $Modules -Scope $ModuleInstallScope

Invoke-psake .\psake.ps1
