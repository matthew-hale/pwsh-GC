function Get-GCLabel {
	
	[CmdletBinding()]
	param (
		[Switch]$FindMatches,

		[System.String]$LabelKey,

		[System.String]$LabelValue,

		[ValidateRange(0,1000)][Int32]$Limit = 20,

		[ValidateRange(0,500000)][Int32]$Offset,

		[Switch]$Raw,

		[PSTypeName("GCApiKey")]$ApiKey
	)

	if ( GCApiKey-present $ApiKey ) {
		if ( $ApiKey ) {
			$Key = $ApiKey
		} else {
			$Key = $global:GCApiKey
		} 
		$Uri = "/visibility/labels"
	}
	
	# Building the request body with given parameters
	
	$Body = @{
	find_matches = $FindMatches:isPresent
	key = $LabelKey
	value = $LabelValue
	limit = $Limit
	offset = $Offset
	}

	# Removing empty keys

	$RequestBody = Remove-EmptyKeys $Body

	# Making the call

	if ( $Raw ) {
		pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
	} else {
		pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCLabel"); $_}
	}
}
