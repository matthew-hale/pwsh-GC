function pwsh-GC-delete-request {
	[cmdletbinding()]

	param (
		[Parameter(Mandatory)]
		[String]$Uri,

		[PSTypeName("GCApiKey")]$ApiKey
	)
	
	if ( $ApiKey ) {
		$RequestToken = $ApiKey.Token
		$RequestUri = $ApiKey.Uri + $Uri
	} else {
		$RequestToken = $global:GCApiKey.Token
		$RequestUri = $global:GCApiKey.Uri + $Uri
	}

	try {
		Invoke-RestMethod -Uri $RequestUri -Method Delete -Authentication Bearer -Token $RequestToken
	}
	catch {
		throw $_.Exception
	}
}

