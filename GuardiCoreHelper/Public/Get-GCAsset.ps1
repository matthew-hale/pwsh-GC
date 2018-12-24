<#
.SYNOPSIS
	Encapsulates the "GET /assets" API call.

.DESCRIPTION
	Searches can be based on hostname, domain name, IP, etc. Note that if seraching by IP, GuardiCore's search may return more assets than the one with the specific IP given. An example of this is a search for "10.0.0.1" returning assets with IPs "10.0.0.12", "10.0.0.100", and "10.0.0.1". Additional parsing may be required.

.PARAMETER Search
	[System.String] A generic search string.

.PARAMETER Status
	[System.String] Status of the asset; accepts "on" or "off".

.PARAMETER Risk
	[Int32] Risk level, from 0 to 3.

.PARAMETER Limit
	[Int32] Max number of results returned.

.PARAMETER Offset
	[Int32] Position of beginning of result range.

.INPUTS
	[System.String] $Search parameter

.OUTPUTS
	[System.Array] Asset objects
#>
function Get-GCAsset {

	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$false)][System.String]$Search,
		[Parameter(Mandatory=$false)][ValidateSet("on","off")][System.String]$Status,
		[Parameter(Mandatory=$false)][ValidateRange(0,3)][Int32]$Risk,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Limit = 20,
		[Parameter(Mandatory=$false)][System.Array]$Label,
		[Parameter(Mandatory=$false)][System.Array]$Asset,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Offset
	)
	process {
		$Key = $global:GCApiKey
		$Uri = $Key.Uri + "assets?"
		
		#Building the Uri with given parameters
		$Uri += "limit=" + $Limit
		
		if ($Search) {
			$TempUri += "&search=" + $Search
		}
		
		if ($Status) {
			$Uri += "&status=" + $Status
		}
		
		if ($Risk) {
			$Uri += "&risk=" + $Risk
		}
		
		if ($Label) {
			$Uri += "&labels="
			$Uri += foreach ($ID in $Label) {$ID.id}
			$Uri = $Uri.Replace(" ",",")
		}
		
		if ($Asset) {
			$Uri += "&asset="
			$Uri += foreach ($ID in $Asset) {"vm:" + $ID.id}
			$Uri = $Uri.Replace(" ",",")
		}
		
		if ($Offset) {
			$Uri += "&offset=" + $Offset
		}
	}
	end {
		Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects"
	}
}