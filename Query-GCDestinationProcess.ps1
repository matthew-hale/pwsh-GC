param (
	[Parameter(mandatory=$false)][String]$Key,
	[Parameter(mandatory=$false)][String]$Value,
	[Parameter(mandatory=$false)][Object[]]$Pairs
)

#This set of queries returns the source processes (a combination of the process name and its corresponding executable) of all flows where the destination node was a member of the label specified by the Key and Value parameters (i.e. what processes did this label use to listen for connections)

#Supports AND filtering of multiple labels, specified by an array of Key="", Value="" pscustomobjects

#Querying flows:
$Labels = Get-Content "./Data/Labels/labels.json" | ConvertFrom-Json

$FlowPath = Get-ChildItem "./Data/Flows" -Filter *.json
$Flows = foreach ($File in $FlowPath) {
	Get-Content $File | ConvertFrom-Json
}

if ($Pairs) {
	$LabelIDs = @()
	foreach ($Pair in $Pairs) {
		$Label = $Labels | where {($_.key -eq $Pair.Key) -and ($_.value -eq $Pair.Value)}
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

$DestinationProcesses = $Flows | where {$LabelIDs -contains $_.destination_node_id} | select -property destination_process,destination_process_name,destination_port | foreach {$_.destination_process + "\" + $_.destination_process_name + "\" + $_.destination_port} | sort -Unique

$Result = foreach ($P in $DestinationProcesses) {
	$Split = $P.split("\")
	[PSCustomObject]@{
		Name = $Split[0].trim()
		Executable = $Split[1].trim()
		Port = $Split[2].trim()
	}
}

$Result
