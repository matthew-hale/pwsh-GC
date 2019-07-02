#using module $PSScriptRoot\class\pwsh-GC.Class1.psm1
# Above needs to remain the first line to import Classes
# Remove the comment when using classes

# Get public and private function definition files.
[array]$Public = Get-ChildItem -Path "$PSScriptRoot/public/*.ps1" -Recurse -ErrorAction SilentlyContinue
[array]$Private = Get-ChildItem -Path "$PSScriptRoot/private/*.ps1" -Recurse -ErrorAction SilentlyContinue

# Dot source the files
Foreach ($Import in @($Public + $Private)) {
    Try {
        . $Import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.fullname): $_"
    }
}

# Create desired aliases
New-Alias -Name gcapi -Value Get-GCApiKey

# Export the public functions and aliases
Export-ModuleMember -Function $Public.Basename -Alias * 

# Credit: https://github.com/MSAdministrator/TemplatePowerShellModule/blob/master/TemplatePowerShellModule/ModuleName.psm1

