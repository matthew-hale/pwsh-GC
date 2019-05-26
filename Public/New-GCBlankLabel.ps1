function New-GCBlankLabel {
	[cmdletbinding()]

	param (
		[Parameter(Mandatory)]
		[String]$LabelKey,

		[Parameter(Mandatory)]
		[String]$LabelValue,

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

	$Body = [PSCustomObject]@{
		id = $null
		key = $LabelKey
		value = $LabelValue
		criteria = @()
	}

	pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
}
