<#
.SYNOPSIS
	Encapsulates the "GET /connections" API request.

.DESCRIPTION
	Returns a set of raw network flows within a given time range, and optionally exports the result to a given path.

.PARAMETER

.INPUTS

.OUTPUTS

#>
function Get-GCRawFlow {
	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)][DateTime]$StartTime,
		[Parameter(Mandatory=$true)][DateTime]$EndTime,
		[Parameter(Mandatory=$false)][ValidateScript({
			if (-not ($_ | Test-Path)) {
				throw "Path does not exist."
			}

			if (-not ($_ | Test-Path -PathType Container)) {
				throw "Target must be a directory. Direct file paths not allowed."
			}

			$true
		})][System.IO.FileInfo]$OutPath
	)
	
	#Ensure the out path has no trailing slash, if it exists
	if ($OutPath) {
		if (($OutPath[$OutPath.length-1] -eq "/") -or ($OutPath[$OutPath.length-1] -eq "\")) {
			$OutPath = $OutPath.SubString(0,$OutPath.length-1)
		}
	}
	
	$FromTime = ConvertTo-GCUnixTime -DateTime $StartTime
	$ToTime = ConvertTo-GCUnixTime -DateTime $EndTime

	$Offset = 0

	# We only want to evaluate the variable once.
	if ($OutPath) {
		do {
			$TempFlows = Get-GCRawFlowPrivate -Offset $Offset -Limit 1000 -FromTime $FromTime -ToTime $ToTime
			$Offset += 1000

			$Uid = Get-Date | ConvertTo-GCUnixTime
			$TempFlows | Export-CSV "$OutPath/flow_$Uid.csv"
		} while (($TempFlows.Count -eq 1000) -and ($Offset -le 499000))
	} else {
		$Flows = [System.Collections.Generic.List[object]]::new()

		do {
			$TempFlows = Get-GCRawFlowPrivate -Offset $Offset -Limit 1000 -FromTime $FromTime -ToTime $ToTime
			$Offset += 1000
	
			$Flows.AddRange($TempFlows)
		} while (($TempFlows.Count -eq 1000) -and ($Offset -le 499000))

		$Flows
	}
}
