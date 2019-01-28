param (
	[Parameter(mandatory=$false)][String]$Key,
	[Parameter(mandatory=$false)][String]$Value,
	[Parameter(mandatory=$false)][Object[]]$Pairs,
	[Parameter(Mandatory=$true)][ValidateScript({
		if (-not ($_ | Test-Path)) {
			throw "Path does not exist."
		}
		if (-not ($_ | Test-Path -PathType Container)) {
			throw "Target must be a directory. Direct file paths not allowed."
		}
		$true
	})][System.IO.FileInfo]$DatasetPath
)

[String]$DatasetPath = [String]$DatasetPath #There's a reason for this...

if (($DatasetPath[$DatasetPath.length-1] -eq "/") -or ($DatasetPath[$DatasetPath.length-1] -eq "\")) {
	$DatasetPath = $DatasetPath.SubString(0,$DatasetPath.length-1)
}

#This set of queries returns the source processes (a combination of the process name and its corresponding executable) of all flows where the destination node was a member of the label specified by the Key and Value parameters (i.e. what processes did this label use to listen for connections)

#Supports AND filtering of multiple labels, specified by an array of Key="", Value="" pscustomobjects

#Querying flows:
$Labels = Get-Content "$DatasetPath/Data/Labels/labels.json" | ConvertFrom-Json

$FlowPath = Get-ChildItem "$DatasetPath/Data/Flows" -Filter *.csv
$Flows = foreach ($File in $FlowPath) {
	Import-CSV $File
}

$Total = $Flows | Get-GCFlowTotal

if ($Pairs) {
	$LabelIDs = @()
	foreach ($P in $Pairs) {
		$Label = $Labels | where {($_.key -eq $P.Key) -and ($_.value -eq $P.Value)}
		$Matches = $Label.matching_assets._id
		$Added = $Label.added_assets._id
		$TempIDs = $Matches + $Added
		if (-not ($IDs)) {
			$IDs = $TempIDs
		}
		$IDs = $IDs | where {$TempIDs -contains $_}
	}
} else {
	$Label = $Labels | where {($_.key -eq $Key) -and ($_.value -eq $Value)}
	$Matches = $Label.matching_assets._id
	$Added = $Label.added_assets._id
	$LabelIDs = $Matches + $Added
}

$LabelFlows = $Flows | where {$LabelIDs -contains $_.source_node_id}
$LabelTotal = $LabelFlows | Get-GCFlowTotal

$SourceProcesses = $LabelFlows | select -Property source_process,source_process_name | foreach {$_.source_process + "\" + $_.source_process_name} | sort -Unique

$Result = foreach ($P in $SourceProcesses) {
	$Split = $P.split("\")
	$Name = $Split[0].trim()
	$Executable = $Split[1].trim()
	
	$PFlows = $LabelFlows | where {($_.source_process -eq $Name) -and ($_.source_process_name -eq $Executable)}
	
	$Subtotal = $PFlows | Get-GCFlowTotal
	$PercentagePart = [math]::Round(($Subtotal / $LabelTotal)*100,2)
	$PercentageWhole = [math]::Round(($Subtotal / $Total)*100,2)
	
	$Out = [PSCustomObject]@{
		Name = $Name
		Executable = $Executable
		"Connection Count" = $Subtotal
		"Percentage of Label" = $PercentagePart
		"Percentage of Total" = $PercentageWhole
	}
	$Out
}

$Result | Sort -Descending "Connection Count"
