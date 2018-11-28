<#
.SYNOPSIS
	Gets the hostname, if available, of a GuardiCore asset given an IP address.

.DESCRIPTION
	This script takes one or more IP addresses, and makes a series of API calls that fetch the hostname of the given IP. Requires Centra.psm1.

.PARAMETER IP
	[System.Array] One or more IP addresses.

.PARAMETER Key
	[PSCustomObject] GuardiCore API key.

.INPUTS
	None. This script has no pipeline input.

.OUTPUTS
	System.Array

#>



Param (
	[Parameter(Mandatory=$true)][System.Array]$IPs,
	[Parameter(Mandatory=$true)][PSCustomObject]$Key
)

$Headers = Set-GCHeaders -Token $Key.Token
$BaseUri = $Key.Uri + "assets?search="
$Output = @()

foreach ($IP in $IPs) {
	$TempUri = $BaseUri + $IP
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