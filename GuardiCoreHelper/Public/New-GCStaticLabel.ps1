<#
.SYNOPSIS
	Encapsulates the "POST /assets/labels/{key}/{value}" API call.

.DESCRIPTION
	Creates a static label with given VMs, specified by unique ID. if the given Key/Value pair already exists, the new VMs are appended to the existing label.

.PARAMETER Asset
	[PSTypeName("GCAsset")] One or more GuardiCore asset objects. Used for static label definitions.

.PARAMETER LabelKey
	[System.String] Key of the label to be updated. Required for both dynamic and static labels.

.PARAMETER LabelValue
	[System.String] Value of the label to be updated. Required for both dynamic and static labels.

.INPUTS
	[PSTypeName("GCAsset")] $Asset parameter; one or more GCAsset objects, as returned by Get-GCAsset.

.OUTPUTS
	[PSCustomObject] application/json data returned from the API request

#>
function New-GCStaticLabel {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][PSCustomObject]$Asset,
		[Parameter(Mandatory=$true)][System.String]$LabelKey,
		[Parameter(Mandatory=$true)][System.String]$LabelValue
	)
	begin {
		$Key = $global:GCApiKey
		
		$Uri = $Key.Uri + "assets/labels/" + $LabelKey + "/" + $LabelValue
		$Body = [PSCustomObject]@{
			"vms" = @()
		}
	}
	process {
		$Body.vms += foreach ($A in $Asset) {
			$A.id
		}
	}
	end {
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
		#$BodyJson
	}
}