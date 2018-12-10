function Import-GCApiKey {
	
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)]$AES, #Path to AES Key
		[Parameter(Mandatory=$true)]$Key #Path to exported API key
	)

	$Import = Import-CSV -Path $Key
	$AES = Get-Content -Path $AES
	$Import.Token = $Import.Token | ConvertTo-SecureString -Key $AES
	$Import
}
