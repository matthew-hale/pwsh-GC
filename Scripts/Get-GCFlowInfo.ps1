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

