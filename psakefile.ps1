Properties {
    $ProjectRoot = $PSScriptRoot
    $PSVersion = $PSVersionTable.PSVersion.Major
    $Timestamp = {Get-Date -format "MM:dd:yyyy-HH:mm:ss.fff"}
    $Lines = "--------------------------------------------------------------------------------"
}

Task Default -Depends Publish

Task Init {
    $Lines
    Set-Location $ProjectRoot
    mkdir "out"
    mkdir "out/pwsh-GC"
    mkdir "out/en-US"
    "`n"
}

Task Build -Depends Init {
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
    New-ExternalHelp -Path "$ProjectRoot/docs/markdown" -OutputPath "$ProjectRoot/out/en-US"

    "`n"
}

Task Pester -Depends Build {
    $Lines
    "Running unit tests"
    $UnitTestResults = Invoke-Pester "$ProjectRoot/tests/unit"

    if ( $UnitTestResults.FailedCount -gt 0 ) {
        Write-Error "Failed '$($UnitTestResults.FailedCount)' tests, build failed"
    }

    "`n"
}

Task Analyze -Depends Build {
    $Lines
    "Running module through PSScriptAnalyzer"
}

Task Test -Depends Analyze,Pester

Task Publish -Depends Test {
}

