<#
.SYNOPSIS
	Encapsulates the GET /incidents API request.

.DESCRIPTION

.PARAMETER StartTime
	The start of the time range.

.PARAMETER EndTime
	The end of the time range.

.PARAMETER Severity
	The severity of the incident; accepts "Low","Medium","High"

.PARAMETER IncidentGroup

.PARAMETER IncidentType

.PARAMETER SourceLabel
	One or more GCLabel objects in the source of the policy.

.PARAMETER DestinationLabel
	One or more GCLabel objects in the destination of the policy.

.PARAMETER AnySideLabel
	One or more GCLabel objects in the source or the destination of the policy.

.PARAMETER SourceAsset
	One or more GCAsset objects in the source of the policy.

.PARAMETER DestinationAsset
	One or more GCAsset objects in the destination of the policy.

.PARAMETER AnySideAsset
	One or more GCAsset objects in the source or the destination of the policy.

.PARAMETER IncludeTag
	One or more tags to include in the request.

.PARAMETER ExcludeTag
	One or more tags to exclude in the request.

.PARAMETER Limit
	The maximum number of results to return.

.PARAMETER Offset
	The index of the first result to return.

.INPUTS
	None. This function accepts no pipeline input.

.OUTPUTS
	PSTypeName="GCIncident"

#>
function Get-GCIncident{
	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][DateTime]$StartTime,
		[Parameter(Mandatory=$false)][DateTime]$EndTime,
		[Parameter(Mandatory=$false)][ValidateSet("Low","Medium","High")][System.String[]]$Severity,
		[Parameter(Mandatory=$false)]$IncidentGroup,
		[Parameter(Mandatory=$false)][ValidateSet("Incident","Deception","Network Scan","Reveal","Experimental")]$IncidentType,
		[Parameter(Mandatory=$false)][PSTypeName("GCAsset")]$SourceAsset,
		[Parameter(Mandatory=$false)][PSTypeName("GCAsset")]$DestinationAsset,
		[Parameter(Mandatory=$false)][PSTypeName("GCAsset")]$AnySideAsset,
		[Parameter(Mandatory=$false)][PSTypeName("GCLabel")]$SourceLabel,
		[Parameter(Mandatory=$false)][PSTypeName("GCLabel")]$DestinationLabel,
		[Parameter(Mandatory=$false)][PSTypeName("GCLabel")]$AnySideLabel,
		[Parameter(Mandatory=$false)]$IncludeTag,
		[Parameter(Mandatory=$false)]$ExcludeTag,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)]$Limit = 20,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Offset = 0
	)
	begin {
		$Key = $Global:GCApiKey
		
		$Uri = $Key.Uri + "incidents?sort=-start_time"
		
		if (-not $StartTime) {
			$StartTime = $(Get-Date).AddHours(-1)
		}
		
		if (-not $EndTime) {
			$EndTime = Get-Date
		}
		
		[Int64]$StartTime = $StartTime | ConvertTo-GCUnixTime
		[Int64]$EndTime = $EndTime | ConvertTo-GCUnixTime
		
		$Uri += "&from_time=" + $StartTime + "&to_time=" + $EndTime + "&limit=" + $Limit + "&offset=" + $Offset
		
		if ($Severity) {
			$Uri += "&severity="
			foreach ($S in $Severity) {
				$Uri += $S + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}
		
		if ($IncidentType) {
			$Uri += "&incident_type="
			foreach ($I in $IncidentType) {
				$Uri += $I + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}

		if ($IncludeTag) {
			$Tags = $IncludeTag -Join ","
			$Uri += "&tag=" + $Tags
		}
		
		if ($ExcludeTag) {
			$Tags = $ExcludeTag -Join ","
			$Uri += "&tags__not=" + $Tags
		}

		### SOURCE ###
		
		$Uri += "&source="
		
		if ($SourceLabel) {
			$Uri += "labels:"
			foreach ($L in $SourceLabel) {
				$Uri += $L.id + "|"
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing "|"
		}
		
		if ($SourceAsset) {
			$Uri += "assets:"
			foreach ($A in $SourceAsset) {
				$Uri += $A.id + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}
		
		if ($Uri[$Uri.length-1] -eq "=") {
			$Uri = $Uri.SubString(0,$Uri.Length-8)
		}
		
		### DESTINATION ###
		
		$Uri += "&destination="
		
		if ($DestinationLabel) {
			$Uri += "labels:"
			foreach ($L in $DestinationLabel) {
				$Uri += $L.id + "|"
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing "|"
		}
		
		if ($DestinationAsset) {
			$Uri += "assets:"
			foreach ($A in $DestinationAsset) {
				$Uri += $A.id + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}
		
		if ($Uri[$Uri.length-1] -eq "=") {
			$Uri = $Uri.SubString(0,$Uri.Length-13)
		}
		
		### ANY SIDE ###
		$Uri += "&any_side="
		
		if ($AnySideLabel) {
			$Uri += "labels:"
			foreach ($L in $AnySideLabel) {
				$Uri += $L.id + "|"
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing "|"
		}
		
		if ($AnySideAsset) {
			$Uri += "assets:"
			foreach ($A in $AnySideAsset) {
				$Uri += $A.id + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}
		
		if ($Uri[$Uri.length-1] -eq "=") {
			$Uri = $Uri.SubString(0,$Uri.Length-10)
		}
	}
	process {
		try {
			$Result = $(Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects") | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCIncident"); $_}
		}
		catch {
			throw $_.Exception
		}
	}
	end {
		$Result
	}
}
