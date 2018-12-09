param (
	[Parameter(mandatory=$false)][String]$Key,
	[Parameter(mandatory=$false)][String]$Value,
	[Parameter(mandatory=$false)][Object[]]$Pairs
)

#This set of queries returns the source processes (a combination of the process name and its corresponding executable) of all flows where the destination node was a member of the label specified by the Key and Value parameters (i.e. what processes did this label use to listen for connections)

#Supports AND filtering of multiple labels, specified by an array of Key="", Value="" pscustomobjects

#Querying flows:
$Dataset = Get-ChildItem "./Data/Labels" -Filter *.xml

if ($Pairs) {
	$LabelIDs = @()
	
	foreach ($Pair in $Pairs) {
		$Pkey = $Pair.Key
		$PValue = $Pair.Value
		
		$LabelResult = foreach ($File in $Dataset) {
			$XPath = "//child::Label[key='$PKey' and value='$PValue']"
			[Xml]$Xml = Get-Content $File
			$Xml | Select-Xml -XPath $XPath | Select-Object -ExpandProperty Node
		}
		
		$TempIDs = @()
		
		if ($LabelResult.matching_assets._id) {
		$TempIDs += $LabelResult.matching_assets._id.split(" ")
		}

		if ($LabelResult.added_assets._id) {
		$TempIDs += $LabelResult.added_assets._id.split(" ")
		}
		
		if (-not ($LabelIDs)) {
			$LabelIDs = $TempIDs
		}
		
		$LabelIDs = $LabelIDs | where {$TempIDs -contains $_}
	}
} else {
	$LabelResult = foreach ($File in $Dataset) {
		$XPath = "//child::Label[key='$Key' and value='$Value']"
		[Xml]$Xml = Get-Content $File
		$Xml | Select-Xml -XPath $XPath | Select-Object -ExpandProperty Node
	}

	$LabelIDs = @()

	if ($LabelResult.matching_assets._id) {
	$LabelIDs += $LabelResult.matching_assets._id.split(" ")
	}

	if ($LabelResult.added_assets._id) {
	$LabelIDs += $LabelResult.added_assets._id.split(" ")
	}
}


$Dataset = Get-ChildItem "./Data/Flows" -Filter *.xml
$FlowResult = foreach ($File in $Dataset) {
	$XPath = "//Flow[contains('$LabelIDs',destination_node_id)]"
	[Xml]$Xml = Get-Content $File
	$Xml | Select-Xml -XPath $XPath | Select-Object -ExpandProperty Node
}

$DestinationProcesses = $FlowResult | select -Property destination_process,destination_process_name,destination_port | foreach {$_.destination_process + "\" + $_.destination_process_name + "\" + $_.destination_port} | sort -Unique

$Result = foreach ($P in $DestinationProcesses) {
	$Split = $P.split("\")
	[PSCustomObject]@{
		Name = $Split[0].trim()
		Executable = $Split[1].trim()
		Port = $Split[2].trim()
	}
}

$Result
