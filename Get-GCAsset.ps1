<#
.SYNOPSIS
	Gets the hostname, if available, of a GuardiCore asset given an IP address.

.DESCRIPTION
	This script takes one or more IP addresses, and makes a series of API calls that fetch the hostname of the given IP. Requires Centra.psm1.

.PARAMETER Server
	[System.String] The name of the GuardiCore management server from which to fetch the information, formatted like "cus-5555".

.PARAMETER IP
	[System.Array] One or more IP addresses.

.PARAMETER Token
	[System.String] GuardiCore API token. The script will prompt for credentials if no token is provided.

.INPUTS
	None. This script has no pipeline input.

.OUTPUTS
	System.Array

#>



Param (
	[Parameter(Mandatory=$true)][System.String]$Server,
	[Parameter(Mandatory=$true)][System.Array]$IPs,
	[System.String]$Token
)

#Gets an API token via Get-GCAPIKey if no token was provided
If (-Not ($Token)) {
	$Token = Get-GCAPIKey -Server $Server
}

$Headers = Set-GCHeaders -Token $Token
$Uri = "https://" + $Server + ".cloud.guardicore.com/api/v3.0/assets?search="
$Output = @()

foreach ($IP in $IPs) {
	$TempUri = $Uri + $IP
	$Json = Invoke-WebRequest -UseBasicParsing -Headers $Headers -Uri $TempUri
	$JsonParsed = $Json.Content | ConvertFrom-Json
	$Objects = $JsonParsed.objects
	
	foreach ($Object in $Objects) {
		if ($Object.ip_addresses -eq $IP) {
			$Name = $Object.name
		}
	}
	
	$LineOut = [PSCustomObject]@{
		IP = $IP
		Name = $Name
	}
	
	If (-Not ($LineOut.Name)) {
		$LineOut.Name = "N/A"
	}
	
	$Output += $LineOut
}

$Output