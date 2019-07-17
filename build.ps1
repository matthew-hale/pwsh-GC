[cmdletbinding()]
param (
    $Task = "Default",
)

$Modules = @(
    "pester",
    "psake",
    "platyPS",
    "PSScriptAnalyzer"
)

$ModuleInstallScope = "CurrentUser"

Install-Module -Name $Modules -Scope $ModuleInstallScope -Force

Invoke-psake -taskList $Task

