#using module $PSScriptRoot\GuardiCoreHelper\Class\GuardiCoreHelper.Class1.psm1
#Above needs to remain the first line to import Classes
#Remove the comment when using classes

#Get public and private function definition files.
$Public = Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1" -Recurse -ErrorAction SilentlyContinue
$Private = Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1" -Recurse -ErrorAction SilentlyContinue

#Dot source the files
Foreach ($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

#Export the public functions
Export-ModuleMember -Function $Public.Basename

#Credit: https://github.com/MSAdministrator/TemplatePowerShellModule/blob/master/TemplatePowerShellModule/ModuleName.psm1