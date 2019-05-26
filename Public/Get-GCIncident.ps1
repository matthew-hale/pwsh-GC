function Get-GCIncident{
	
	[CmdletBinding()]
	param (
		[DateTime]$StartTime,

		[DateTime]$EndTime,

		[ValidateSet("Low","Medium","High")][System.String[]]$Severity,

		[ValidateSet("Incident","Deception","Network Scan","Reveal","Experimental")]$IncidentType,

		[String]$SourceAsset,

		[String]$DestinationAsset,

		[String]$AnySideAsset,

		[PSTypeName("GCLabel")]$SourceLabel,

		[PSTypeName("GCLabel")]$DestinationLabel,

		[PSTypeName("GCLabel")]$AnySideLabel,

		[System.Array]$IncludeTag,

		[System.Array]$ExcludeTag,

		[ValidateRange(0,1000)]$Limit = 20,

		[ValidateRange(0,500000)][Int32]$Offset = 0,

		[PSTypeName("GCApiKey")]$ApiKey
	)

	if (GCApiKey-present $ApiKey) {
		if ($ApiKey) {
			$Key = $ApiKey
		} else {
			$Key = $global:GCApiKey
		} 
		# This sort is required for legacy URI building
		$Uri = "/incidents?sort=-start_time" 
	}

	# Handling start and end time defaults

	if ( -not $StartTime ) {
		$StartTime = $(Get-Date).AddHours(-1)
	}
	
	if ( -not $EndTime ) {
		$EndTime = Get-Date
	}
	
	[Int64]$StartTime = $StartTime | ConvertTo-GCUnixTime
	[Int64]$EndTime = $EndTime | ConvertTo-GCUnixTime
	
	# Building request body with parameters
	
	$Body = @{
		from_time = $StartTime
		to_time = $EndTime
		severity = $Severity
		incident_type = $IncidentType
		tag = $IncludeTag
		tags__not = $ExcludeTag
	}

	# Removing empty keys

	$RequestBody = Remove-EmptyKeys $Body


	# This legacy URI building is actually necessary,
	# due to the complicated way in which the URI needs to be structured.
	### SOURCE ###
	
	$Uri += "&source="
	
	if ($SourceLabel) {
		$Uri += "labels:"
		foreach ($L in $SourceLabel) {
			$Uri += $L.id -join "|"
		}
	}
	
	if ($SourceAsset) {
		$Uri += "assets:"
		foreach ($A in $SourceAsset) {
			$Uri += $A -join ","
		}
	}
	
	if ($Uri[$Uri.length-1] -eq "=") {
		$Uri = $Uri.SubString(0,$Uri.Length-8)
	}
	
	### DESTINATION ###
	
	$Uri += "&destination="
	
	if ($DestinationLabel) {
		$Uri += "labels:"
		foreach ($L in $DestinationLabel) {
			$Uri += $L.id -join "|"
		}
	}
	
	if ($DestinationAsset) {
		$Uri += "assets:"
		foreach ($A in $DestinationAsset) {
			$Uri += $A -join ","
		}
	}
	
	if ($Uri[$Uri.length-1] -eq "=") {
		$Uri = $Uri.SubString(0,$Uri.Length-13)
	}
	
	### ANY SIDE ###
	$Uri += "&any_side="
	
	if ($AnySideLabel) {
		$Uri += "labels:"
		foreach ($L in $AnySideLabel) {
			$Uri += $L.id -join "|"
		}
	}
	
	if ($AnySideAsset) {
		$Uri += "assets:"
		foreach ($A in $AnySideAsset) {
			$Uri += $A -join ","
		}
	}
	
	if ($Uri[$Uri.length-1] -eq "=") {
		$Uri = $Uri.SubString(0,$Uri.Length-10)
	}

	# Making the call

	if ( $Raw ) {
		$Result = pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
	} else {
		$Result = pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCIncident"); $_}
	}

	$Result
}
