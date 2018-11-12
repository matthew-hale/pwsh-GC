<#
Returns custom object containing basic, useful information from a set of flows
"Useful information" includes process name, count, source ip, and destination ip, sorted by unique where applicable
#>

Param (
	[Parameter(Mandatory=$true)][System.Array]$Flows
)

$SourceProcess = $Flows.source_process_name | Sort -Unique
$Count = $Flows.count
$Sources = $Flows.source_ip | Sort -Unique
$Destinations = $Flows.destination_ip | Sort -Unique
$DestinationProcesses = $Flows.destination_process_name | Sort -Unique
$DestinationPorts = $Flows.destination_port | Sort -Unique

$Output = [PSCustomObject]@{
	"Process Name" = $SourceProcess
	Count = $Count
	Sources = $Sources
	Destinations = $Destinations
	"Destination Processes" = $DestinationProcesses
	"Destination Ports" = $DestinationPorts
}

Return $Output