<#
.SYNOPSIS
	Encapsulates the "GET /connections" API call.

.DESCRIPTION
	

.PARAMETER
	

.INPUTS
	

.OUTPUTS
	

#>
function Get-GCRawFlow {
	
	[cmdletbinding()]
	param (
		[DateTime]$StartTime,
		[DateTime]$EndTime,
		[System.Array]$SourceProcess,
		[System.Array]$DestinationProcess,
		[System.Array]$AnySideProcess,
		[System.Array]$SourceAsset,
		[System.Array]$DestinationAsset,
		[System.Array]$AnySideAsset,
		[System.Array]$SourceLabel,
		[System.Array]$DestinationLabel,
		[System.Array]$AnySideLabel,
		[Int32]$Limit,
		[Int32]$Offset
	)
	begin {
		$Key = $global:GCApiKey
	}
	process {
		$Uri = $Key.Uri + "connections?sort=-slot_start_time"
		
		#Building the Uri with given parameters
		if ($StartTime) {
			$FromTime = ConvertTo-GCUnixTime $StartTime
			$Uri += "&from_time=" + $FromTime
		}

		if ($EndTime) {
			$ToTime = ConvertTo-GCUnixTime $EndTime
			$Uri += "&to_time=" + $ToTime
		}

		if ($Limit) {
			$Uri += "&limit=" + $Limit
		}

		if ($Offset) {
			$Uri += "&offset=" + $Offset
		}

		### Source ###

		if ($SourceProcess -or $SourceAsset -or $SourceLabel) {
			$Uri += "&source="
		}

		if ($SourceProcess) {
			$Uri += "processes:"
			$Uri += $SourceProcess -Join ","
		}

		if ($SourceAsset) {
			$Uri += "assets:"
			$Uri += $SourceAsset.id -Join ","
		}

		if ($SourceLabel) { #2D array; outer group is OR, inner groups are AND
			$Uri += "labels:"
			foreach ($Group in $SourceLabel) {
				$Uri += $Group.id -Join ">"
				$Uri += "|"
			}

			$Uri = $Uri.SubString(0,$Uri.Length-1) #Removing last "|"
		}

		### Destination ###

		if ($DestinationProcess -or $DestinationAsset -or $DestinationLabel) {
			$Uri += "&destination="
		}

		if ($DestinationProcess) {
			$Uri += "processes:"
			$Uri += $DestinationProcess -Join ","
		}

		if ($DestinationAsset) {
			$Uri += "assets:"
			$Uri += $DestinationAsset.id -Join ","
		}

		if ($DestinationLabel) {
			$Uri += "labels:"
			foreach ($Group in $DestinationLabel) {
				$Uri += $Group.id -Join ">"
				$Uri += "|"
			}

			$Uri = $Uri.SubString(0,$Uri.Length-1) #Removing last "|"
		}

		### Any Side ###

		if ($AnySideProcess -or $AnySideAsset -or $AnySideLabel) {
			$Uri += "&any_side="
		}

		if ($AnySideProcess) {
			$Uri += "processes:"
			$Uri += $AnySideProcess -Join ","
		}

		if ($AnySideAsset) {
			$Uri += "assets:"
			$Uri += $AnySideAsset.id -Join ","
		}

		if ($AnySideLabel) {
			$Uri += "labels:"
			foreach ($Group in $AnySideLabel) {
				$Uri += $Group.id -Join ">"
				$Uri += "|"
			}
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Removing last "|"
		}
	}
	end {
		$(Invoke-RestMethod -Authentication Bearer -Token $Key.Token -Uri $Uri -Method "GET" | Select-Object -ExpandProperty "objects") | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCRawFlow"); $_}
	}
}
