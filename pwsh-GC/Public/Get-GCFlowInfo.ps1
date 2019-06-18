function Get-GCFlowInfo {
	
	[CmdletBinding()]
	param (
		#An array of flows, as formatted from GuardiCore (converted from JSON).
		[Parameter(ValueFromPipeline=$true)][System.Array]$Flows,
		[System.String]$Title = "Flows"
	)
	process {
		foreach ($Flow in $Flows) {
			$InputFlows.Add($Flow)
		}

		$Count = $InputFlows.count
		$Total = $InputFlows | Get-GCFlowTotal
		$Sources = $InputFlows.source_ip | Sort-Object -Unique
		$SourceProcesses = $InputFlows.source_process_name | Sort-Object -Unique
		$Destinations = $InputFlows.destination_ip | Sort-Object -Unique
		$DestinationProcesses = $InputFlows.destination_process_name | Sort-Object -Unique
		$DestinationPorts = $InputFlows.destination_port | Sort-Object -Unique

		[PSCustomObject]@{
			"Title" = $Title
			"Total Flows" = $Count
			"Total Connections" = $Total
			"Sources" = $Sources
			"Source Processes" = $SourceProcesses
			"Destinations" = $Destinations
			"Destination Processes" = $DestinationProcesses
			"Destination Ports" = $DestinationPorts
		}
	}
}

