Properties {
    $ProjectRoot = $PSScriptRoot
    $PSVersion = $PSVersionTable.PSVersion.Major
    $Timestamp = {Get-Date -format "MM:dd:yyyy-HH:mm:ss.fff"}
    $Lines = "--------------------------------------------------------------------------------"
}

Task Default -Depends Publish

Task Init {
    Import-Module pester,platyPS,PSScriptAnalyzer
    $Lines
    "Make required output folders"
    Set-Location $ProjectRoot
    mkdir "out"
    mkdir "out/pwsh-GC"
    mkdir "out/pwsh-GC/en-US"
    "`n"
}

Task Analyze -Depends Init {
    $Lines
    "Running module through PSScriptAnalyzer"

    $PublicFunctions = Get-ChildItem "$ProjectRoot/pwsh-GC/public/*.ps1"
    $AnalyzerResults = foreach ( $Function in $PublicFunctions ) {
        Invoke-ScriptAnalyzer $Function
    }

    $AnalyzerResults

    $FailedCount = ($AnalyzerResults| Where-Object {$_.Severity -eq "Error"}).count

    Assert ( $FailedCount -eq 0 ) "Failed $FailedCount PSScriptAnalyzer rules, build failed"
}

Task Build -Depends Analyze {
    $Lines
    "Concatenating functions into module file"
    $ModuleFilePath = Join-Path $ProjectRoot "out" "pwsh-GC" "pwsh-GC.psm1"
    $ModuleFile = New-Item $ModuleFilePath
    $PrivateFunctions = Get-ChildItem "$ProjectRoot/pwsh-GC/private/*.ps1"
    $PublicFunctions = Get-ChildItem "$ProjectRoot/pwsh-GC/public/*.ps1"
    $ExportFunctions = foreach ( $Function in $PublicFunctions ) {
        $Function.BaseName
    }

    foreach ( $Function in $PublicFunctions ) {
        Get-Content $Function | Add-Content $ModuleFile
    }

    $ExportString = "Export-ModuleMember -Function " + ($ExportFunctions -Join ",")
    $ExportString | Add-Content $ModuleFile
    "Set-Alias gcapi Get-GCApiKey" | Add-Content $ModuleFile
    "Export-ModuleMember -Alias gcapi" | Add-Content $ModuleFile
    "" | Add-Content $ModuleFile

    foreach ( $Function in $PrivateFunctions ) {
        Get-Content $Function | Add-Content $ModuleFile
    }

    "Creating en-US maml help file"
    New-ExternalHelp -Path "$ProjectRoot/docs/markdown" -OutputPath "$ProjectRoot/out/pwsh-GC/en-US"

    "Copying manifest"
    Copy-Item "$ProjectRoot/pwsh-GC/pwsh-GC.psd1" "$ProjectRoot/out/pwsh-GC/pwsh-GC.psd1"

    "`n"
}

Task Pester -Depends Build {
    $Lines
    "Running unit tests"

    Import-Module "$ProjectRoot/out/pwsh-GC/pwsh-GC.psd1"
    $TestFunctions = Get-ChildItem "$ProjectRoot/tests/unit/functions/*.ps1"
    foreach ( $File in $TestFunctions ) {
        $FilePath = $File.FullName
        . $FilePath
    }

    $UnitTestResults = Invoke-Pester "$ProjectRoot/tests/unit" -PassThru

    Assert ( $UnitTestResults.FailedCount -eq 0 ) "Failed '$($UnitTestResults.FailedCount)' tests, build failed"

    "`n"
}

Task Test -Depends Analyze,Pester

Task Publish -Depends Test {
    $Lines
    "Publishing not yet implemented"
}

