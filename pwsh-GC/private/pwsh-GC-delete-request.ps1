function pwsh-GC-delete-request {
	[cmdletbinding()]

	param (
		[Parameter(Mandatory)]
		[String]$Uri,

		[Parameter(Mandatory)]
		[PSTypeName("GCApiKey")]$ApiKey
	)
	
	$RequestToken = $ApiKey.Token | ConvertTo-SecureString -AsPlainText -Force
	$RequestUri = $ApiKey.Uri + $Uri

	try {
		Invoke-RestMethod -Uri $RequestUri -Method Delete -Authentication Bearer -Token $RequestToken
	}
	catch {
		throw $_.Exception
	}
}

