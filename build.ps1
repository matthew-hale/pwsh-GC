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

foreach ( $Module in $Modules ) {
    if ( -not (Get-Module $Module -ListAvailable) ) {
        Install-Module -Name $Module -Scope $ModuleInstallScope -Force
    }

    Update-Module $Module
    Import-Module $Module
}

Invoke-psake -taskList $Task

