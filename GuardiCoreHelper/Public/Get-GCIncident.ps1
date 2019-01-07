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
		#$Result = $Uri
		$Result = $(Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects") | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCIncident"); $_}
	}
	end {
		$Result
	}
}
