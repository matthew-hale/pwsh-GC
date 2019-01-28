<#
.SYNOPSIS
	Returns a custom object containing basic, useful information from a set of flows. "Useful information" includes process name, count, source ip, destination ip, etc. sorted by unique where applicable.

.DESCRIPTION
	This script is intended to be used with data structures generated by the Get-GCRawFlow api call made to a GuardiCore management server. It takes an array of flows and creates a custom PowerShell object containing sorted data pulled from the array.

	Specifically, the data pulled includes:

	-Source Process Name(s)
	-Destination Process Name(s)
	-Count of flow objects
	-Total number of connections (some flows have more than one connection)
	-Source IP address(es)
	-Destination IP address(es)
	-Destination Port(s)
	
.PARAMETER Flows
	[System.Array] Net flows, as formatted from GuardiCore (converted from JSON). Can also be piped in.
	
.PARAMETER Title
	[System.String] Title of the resultant object. Defaults to "Flows".
	
.INPUTS
	None. This script takes no pipeline inputs.

.OUTPUTS
	System.Object.PSCustomObject

#>
function Get-GCFlowInfo {
	
	[CmdletBinding()]
	param (
		#An array of flows, as formatted from GuardiCore (converted from JSON).
		[Parameter(ValueFromPipeline=$true)][System.Array]$Flows,
		[System.String]$Title = "Flows"
	)
	begin {
		$InputFlows = [System.Collections.Generic.List[object]]::new()
	}
	process {
		foreach ($Flow in $Flows) {
			$InputFlows.Add($Flow)
		}
	}
	end {
		$Count = $InputFlows.count
		$Total = $InputFlows | Get-GCFlowTotal
		$Sources = $InputFlows.source_ip | Sort -Unique
		$SourceProcesses = $InputFlows.source_process_name | Sort -Unique
		$Destinations = $InputFlows.destination_ip | Sort -Unique
		$DestinationProcesses = $InputFlows.destination_process_name | Sort -Unique
		$DestinationPorts = $InputFlows.destination_port | Sort -Unique

		$Output = [PSCustomObject]@{
			"Title" = $Title
			"Total Flows" = $Count
			"Total Connections" = $Total
			Sources = $Sources
			"Source Processes" = $SourceProcesses
			Destinations = $Destinations
			"Destination Processes" = $DestinationProcesses
			"Destination Ports" = $DestinationPorts
		}
		
		$Output
	}
}
