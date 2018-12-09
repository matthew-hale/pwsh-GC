param (
	[Parameter(mandatory=$false)][String]$Key,
	[Parameter(mandatory=$false)][String]$Value,
	[Parameter(mandatory=$false)][Object[]]$Pairs
)

#This set of queries returns the source processes (a combination of the process name and its corresponding executable) of all flows where the source node was a member of the label specified by the Key and Value parameters

#Querying flows:
$Labels = Get-Content "./Data/Labels/labels.json" | ConvertFrom-Json

$FlowPath = Get-ChildItem "./Data/Flows" -Filter *.json
$Flow = foreach ($File in $FlowPath) {
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

$SourceProcesses = $Flows | where {$LabelIDs -contains $_.source_node_id} | select -property source_process,source_process_name | foreach {$_.source_process + "\" + $_.source_process_name} | sort -Unique

$Result = foreach ($P in $SourceProcesses) {
	$Split = $P.split("\")
	[PSCustomObject]@{
		Name = $Split[0].trim()
		Executable = $Split[1].trim()
	}
}

$Result
