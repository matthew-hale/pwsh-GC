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

$LabelFlows = $Flows | where {$LabelIDs -contains $_.destination_node_id}
$LabelTotal = $LabelFlows | Get-GCFlowTotal

$DestinationProcesses = $LabelFlows | select -property destination_process,destination_process_name,destination_port | foreach {$_.destination_process + "\" + $_.destination_process_name + "\" + $_.destination_port} | sort -Unique

$Result = foreach ($P in $DestinationProcesses) {
	$Split = $P.split("\")
	$Name = $Split[0].trim()
	$Executable = $Split[1].trim()
	$Port = $Split[2].trim()
	
	$PFlows = $LabelFlows | where {($_.destination_process -eq $Name) -and ($_.destination_process_name -eq $Executable) -and ($_.destination_port -eq $Port)}
	
	$Subtotal = $PFlows | Get-GCFlowTotal
	$PercentagePart = [math]::Round(($Subtotal / $LabelTotal)*100,2)
	$PercentageWhole = [math]::Round(($Subtotal / $Total)*100,2)
	
	$Out = [PSCustomObject]@{
		Name = $Name
		Executable = $Executable
		Port = $Port
		"Connection Count" = $Subtotal
		"Percentage of Label" = $PercentagePart
		"Percentage of Total" = $PercentageWhole
	}
	$Out
}

$Result | Sort -Descending "Connection Count"
