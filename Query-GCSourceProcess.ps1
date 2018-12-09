param (
	[Parameter(mandatory=$false)][String]$Key,
	[Parameter(mandatory=$false)][String]$Value,
	[Parameter(mandatory=$false)][Object[]]$Pairs
)

#This set of queries returns the source processes (a combination of the process name and its corresponding executable) of all flows where the source node was a member of the label specified by the Key and Value parameters

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
$FlowResult = foreach ($File in $DataSet) {
	$XPath = "//Flow[contains('$LabelIDs',source_node_id)]"
	[Xml]$Xml = Get-Content $File
	$Xml | Select-Xml -XPath $XPath | Select-Object -ExpandProperty Node
}

$SourceProcesses = $FlowResult | select -Property source_process,source_process_name | foreach {$_.source_process + "\" + $_.source_process_name} | sort -Unique

$Result = foreach ($P in $SourceProcesses) {
	$Split = $P.split("\")
	[PSCustomObject]@{
		Name = $Split[0].trim()
		Executable = $Split[1].trim()
	}
}

$Result
