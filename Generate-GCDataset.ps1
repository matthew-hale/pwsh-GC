param (
	[Parameter(Mandatory=$true)][PSCustomObject]$Key,
	[Parameter(Mandatory=$true)][DateTime]$StartTime,
	[Parameter(Mandatory=$true)][DateTime]$EndTime,
	[Parameter(Mandatory=$true)][ValidateScript({
		if (-not ($_ | Test-Path)) {
			throw "Path does not exist."
		}
		if (-not ($_ | Test-Path -PathType Container)) {
			throw "Target must be a directory. Direct file paths not allowed."
		}
		$true
	})][System.IO.FileInfo]$OutPath
)

### This script can take some time to complete. Check the debug messages. ###

Import-Module .\Centra.psm1

[String]$OutPath = [String]$OutPath

if (($OutPath[$OutPath.length-1] -eq "/") -or ($OutPath[$OutPath.length-1] -eq "\")) {
	$OutPath = $OutPath.SubString(0,$OutPath.length-1)
}

$FlowPath = $OutPath + "\Flows"
$DataPath = $OutPath + "\Data"

mkdir $FlowPath > $null
mkdir $DataPath > $null
mkdir "$DataPath\Assets" > $null
mkdir "$DataPath\Labels" > $null
mkdir "$DataPath\Flows" > $null

Write-Host -NoNewLine Getting assets...
$Assets = Get-GCAsset -Key $Key -Offset 0 -Limit 1000
Write-Host done

Write-Host -NoNewLine Generating asset dataset...
$AssetPath = "$DataPath\Assets\assets.json"
$Assets | ConvertTo-Json -Depth 99 > $AssetPath
Write-Host done

Write-Host -NoNewLine Getting labels...
$Labels = Get-GCLabel -Key $Key -FindMatches -Offset 0 -Limit 500
Write-Host done

Write-Host -NoNewLine Generating label dataset...
$LabelPath = "$DataPath\Labels\labels.json"
$Labels | ConvertTo-Json -Depth 99 > $LabelPath
Write-Host done

Write-Host -NoNewLine Getting flows...
.\Get-GCFlowJob.ps1 -Key $Key -StartTime $StartTime -EndTime $EndTime -OutPath $FlowPath
Write-Host done

Write-Host -NoNewLine Generating flow dataset...
$FlowPathFiles = Get-ChildItem $FlowPath -Filter *.csv

foreach ($File in $FlowPathFiles) {
	$Flows = Import-CSV $File
	$Name = $File.Name
	$Name = $Name.SubString(0,$Name.Length-3)
	$Name += "json"
	$Path = "$DataPath\Flows\$Name"
	$Flows | ConvertTo-Json -Depth 99 > $Path
}
Write-Host done

Write-Host Dataset generation complete.
