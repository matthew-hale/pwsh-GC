Properties {
    $ProjectRoot = $PSScriptRoot
    $ModuleName = "pwsh-GC"
    $PublishRepository = [Environment]::GetEnvironmentVariable("Repository")
    $Lines = "--------------------------------------------------------------------------------"
}

Task Default -Depends Publish

Task Init {
    Import-Module pester,platyPS,PSScriptAnalyzer
    $Lines
    "Make required output folders"
    Set-Location $ProjectRoot
    mkdir "out"
    mkdir "out/$ModuleName"
    mkdir "out/$ModuleName/en-US"
    "`n"
}

Task Analyze -Depends Init {
    $Lines
    "Running module through PSScriptAnalyzer"

    $PublicFunctions = Get-ChildItem "$ProjectRoot/$ModuleName/public/*.ps1"
    $AnalyzerResults = foreach ( $Function in $PublicFunctions ) {
        Invoke-ScriptAnalyzer $Function
    }

    $AnalyzerResults

    $FailedCount = ($AnalyzerResults| Where-Object {$_.Severity -eq "Error"}).count

    Assert ( $FailedCount -eq 0 ) "Failed $FailedCount PSScriptAnalyzer rules, build failed"
}

Task Build -Depends Analyze {
    $Lines
    "Concatenating functions into module file`n"

    $ModuleFilePath = Join-Path $ProjectRoot "out" $ModuleName "$ModuleName.psm1"
    $ModuleFile = New-Item $ModuleFilePath
    $PrivateFunctions = Get-ChildItem "$ProjectRoot/$ModuleName/private/*.ps1"
    $PublicFunctions = Get-ChildItem "$ProjectRoot/$ModuleName/public/*.ps1"
    $ExportFunctions = foreach ( $Function in $PublicFunctions ) {
        $Function.BaseName
    }
    $Aliases = Get-Content "$ProjectRoot/$ModuleName/data/aliases.json" | ConvertFrom-Json

    foreach ( $Function in $PublicFunctions ) {
        Get-Content $Function | Add-Content $ModuleFile
    }

    foreach ( $Function in $PrivateFunctions ) {
        Get-Content $Function | Add-Content $ModuleFile
    }


    foreach ( $Alias in $Aliases ) {
        ("Set-Alias -Name " + $Alias.name + " -value " + $Alias.value) | Add-Content $ModuleFile
    }

    "" | Add-Content $ModuleFile

    $ExportString = "Export-ModuleMember -Function " + ($ExportFunctions -Join ",") + " -Alias " + ($Aliases.name -Join ",")
    $ExportString | Add-Content $ModuleFile

    "" | Add-Content $ModuleFile

    "Creating en-US maml help file"
    New-ExternalHelp -Path "$ProjectRoot/docs/markdown" -OutputPath "$ProjectRoot/out/$ModuleName/en-US"

    "Copying manifest"
    Copy-Item "$ProjectRoot/$ModuleName/$ModuleName.psd1" "$ProjectRoot/out/$ModuleName/$ModuleName.psd1"

    "Updating manifest"
    $ManifestParams = @{
        Path = "$ProjectRoot/out/$ModuleName/$ModuleName.psd1"
        FunctionsToExport = $ExportFunctions
        AliasesToExport = $Aliases
    }
    Update-ModuleManifest @ManifestParams

    "`n"
}

Task Pester -Depends Build {
    $Lines
    "Running unit tests"

    Remove-Module $ModuleName -Force
    Import-Module "$ProjectRoot/out/$ModuleName/$ModuleName.psd1"

    $UnitTestResults = Invoke-Pester "$ProjectRoot/tests/unit" -PassThru

    Assert ( $UnitTestResults.FailedCount -eq 0 ) "Failed '$($UnitTestResults.FailedCount)' tests, build failed"

    "`n"
}

Task Test -Depends Analyze,Pester

Task Publish -Depends Test {
    $Lines
    "Publishing to dev repository"
    Publish-Module -Path "$ProjectRoot/out/$ModuleName" -Repository $PublishRepository
}

