<#
.SYNOPSIS
	Encapsulates the "GET /connections" API call.

.DESCRIPTION
	

.PARAMETER
	

.INPUTS
	

.OUTPUTS
	

#>
function Get-GCFlowPrivate {
	
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false)][Int64]$FromTime,
		[Parameter(Mandatory=$false)][Int64]$ToTime,
		[Parameter(Mandatory=$false)][Int32]$Limit,
		[Parameter(Mandatory=$false)][Int32]$Offset
	)
	process {
		$Uri = $Key.Uri + "connections?sort=-slot_start_time"
		
		#Building the Uri with given parameters
		if ($FromTime) {
			$Uri += "&from_time=" + $FromTime
		}

		if ($ToTime) {
			$Uri += "&to_time=" + $ToTime
		}

		if ($Limit) {
			$Uri += "&limit=" + $Limit
		}

		if ($Offset) {
			$Uri += "&offset=" + $Offset
		}
	}
	end {
		Invoke-RestMethod -Authentication Bearer -Token $Key.Token -Uri $Uri -Method "GET" | Select-Object -ExpandProperty "objects"
	}
}
