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

#This set of queries returns the source machines (a combination of the IP and hostname) of all flows where the destination node was a member of the label specified by the Key and Value parameters (i.e. what machines initiated connections to the specified label)

#Supports AND filtering of multiple labels, specified by an array of Key="", Value="" pscustomobjects

$Assets = Get-Content "$DatasetPath/Data/Assets/assets.json" | ConvertFrom-Json

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

$SourceMachines = $LabelFlows | select -property source_ip,source_node_type | foreach {$_.source_ip + ";" + $_.source_node_type} | sort -Unique

$Result = foreach ($S in $SourceMachines) {
	$Split = $S.split(";")
	$IP = $Split[0].trim()
	$Type = $Split[1].trim()
	
	$SFlows = $LabelFlows | where {($_.source_ip -eq $IP) -and ($_.source_node_type -eq $Type)}
	
	if ($Type -eq "asset") {
		$Hostname = $Assets | where {$_.ip_addresses -contains$IP} | select -ExpandProperty vm_name
	} elseif ($Type -eq "subnet") {
		$Hostname = "Unknown"
	} else {
		$Result = nslookup.exe $IP
		if ($Result[3]) {
			if ($Result[3].SubString(0,22) -eq "DNS request timed out.") {
				$Hostname = "Unknown"
			} else {
				$Hostname = $Result[3].split(":").trim()[1]
			}
		} else {
			$Hostname = "Unknown"
		}
	}
	
	$Subtotal = $SFlows | Get-GCFlowTotal
	$PercentagePart = [math]::Round(($Subtotal / $LabelTotal)*100,2)
	$PercentageWhole = [math]::Round(($Subtotal / $Total)*100,2)
	
	$Out = [PSCustomObject]@{
		Hostname = $Hostname
		IP = $IP
		Type = $Type
		"Connection Count" = $Subtotal
		"Percentage of Label" = $PercentagePart
		"Percentage of Total" = $PercentageWhole
	}
	$Out
}

$Result | Sort -Descending "Connection Count"
