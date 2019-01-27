<#
.SYNOPSIS
	Encapsulates the "GET /assets" API call.

.DESCRIPTION
	Searches can be based on hostname, domain name, IP, etc. Note that when seraching, GuardiCore's search may return more assets than the one with the specific string given. An example of this is a search for "10.0.0.1" returning assets with IPs "10.0.0.12", "10.0.0.100", and "10.0.0.1". Additional parsing may be required.

.PARAMETER Search
	[System.String] A generic search string.

.PARAMETER Status
	[System.String] Status of the asset. Allows: "on","off"

.PARAMETER Risk
	[Int32] Risk level. Allows: (0..3)

.PARAMETER Limit
	[Int32] Max number of returned assets.
	
.PARAMETER Offset
	[Int32] Index of where the query will start returning results.

.INPUTS
	[System.String] $Search parameter.

.OUTPUTS
	[PSTypeName("GCAsset")] One or more GCAsset objects.
#>
function Get-GCAsset {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][System.String]$Search,
		[Parameter(Mandatory=$false)][ValidateSet("on","off")][System.String]$Status,
		[Parameter(Mandatory=$false)][ValidateRange(0,3)][Int32]$Risk,
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][PSTypeName("GCLabel")]$Label,
		[Parameter(Mandatory=$false)][PSTypeName("GCAsset")]$Asset,
		[Parameter(Mandatory=$false)][ValidateRange(0,1000)][Int32]$Limit = 20,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Offset
	)
	begin {
		$Key = $Global:GCApiKey
		$Uri = $Key.Uri + "assets?"
		
		#Building the Uri with given parameters
		$Uri += "limit=" + $Limit
		
		if ($Search) {
			$Uri += "&search=" + $Search
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
		$TempLabelUri = "&labels="
	}
	process {
		#This is to handle labels being piped in to this function, as opposed to delivered via parameter.
		#It checks to see if labels were already added to the uri. 
		#If they weren't, but there are labels in the $Labels variable, it iterates through them.
		if (-not ($Uri -match "&labels=") -and $Label) {
			$TempLabelUri += $Label.id + ","
		}
	}
	end {
		if ($TempLabelUri.length -ne 8) {
			$TempLabelUri = $TempLabelUri.SubString(0,$TempLabelUri.Length-1) #Remove trailing ","
			$Uri += $TempLabelUri
		}
		
		try {
			$Result = $(Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects") | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCAsset"); $_}
		}
		catch {
			throw $_.Exception
		}
		
		$Result
	}
}
