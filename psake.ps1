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
    "`n"
}

Task Build -Depends Init {
    $Lines
    "Concatenating functions into module file"
}

Task Pester -Depends Build {
}

Task Analyze -Depends Build {
}

Task Test -Depends Analyze,Pester {
}

Task Publish -Depends Test {
}
