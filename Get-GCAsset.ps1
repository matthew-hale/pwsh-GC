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
$BaseUriAssets = $Key.Uri + "assets?search="
$BaseUriLabels = $Key.Uri + "visibility/labels"
$Output = @()

#Grabbing all the labels here
$TempUri = $BaseUriLabels
$LabelLimit = Invoke-WebRequest -UseBasicParsing -Headers $Headers -Uri $TempUri | ConvertFrom-Json | Select-Object -ExpandProperty "total_count"
$TempUri += "?offset=0&limit=" + $LabelLimit
$Labels = Invoke-WebRequest -UseBasicParsing -Headers $Headers -Uri $TempUri | ConvertFrom-Json | Select-Object -ExpandProperty "objects"

foreach ($IP in $IPs) {
	$TempUri = $BaseUriAssets + $IP
	$Assets = Invoke-WebRequest -UseBasicParsing -Headers $Headers -Uri $TempUri | ConvertFrom-Json | Select-Object -ExpandProperty "objects"
	
	$LineOut = [PSCustomObject]@{
		IP = $IP
		Name = ""
		Label = @()
	}
	
	foreach ($Asset in $Assets) {
		if ($Asset.ip_addresses -eq $IP) {
			$LineOut.Name = $Asset.name
			$LineObject = $Asset
		}
	}
	
	If ($LineOut.Name -eq "") {
		$LineOut.Name = "N/A"
	}
	
	foreach ($Label in $LineObject.labels) {
		$MatchingLabel = $Labels | Where id -eq $Label
		
		$LineOut.Label += $MatchingLabel.key + ": " + $MatchingLabel.value
	}
	
	$Output += $LineOut
}

$Output