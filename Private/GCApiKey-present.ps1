function GCApiKey-present {
	[cmdletbinding()]

	param (
		$ApiKey
	)

	if ( -not ($ApiKey -or $global:GCApiKey) ) {
		throw "No API key present."
	} else {
		return $true
	}
}

