<#
.SYNOPSIS
	Returns the total number of connections in a given array of GuardiCore flow objects.

.DESCRIPTION
	Each flow has a "count" field that increments whenever an identical flow is recorded. To obtain the true total number of connections for a given set of flow objects, this function sums each individual count field.

.PARAMETER Flow
	[System.Array] GuardiCore flow objects.

.INPUTS
	[System.Array] $Flow parameter.

.OUTPUTS
	[Int32] Total count.

#>
function Get-GCFlowTotal {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][System.Array]$Flow
	)
	
	begin {
		$Subtotal = 0
	}
	process {
		foreach ($F in $Flow) {
			$SubTotal += $F.Count
		}
	}
	end {
		[Int32]$Subtotal
	}
}
