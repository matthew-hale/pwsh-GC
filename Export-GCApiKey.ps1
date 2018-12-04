Param (
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject]$Key,
	[Parameter(Mandatory=$true)]$AES #Path to AES key

)
Begin {
	$Export = [PSCustomObject]@{
		Token = ""
		Uri = ""
	}
	
	$AES = Get-Content -Path $AES
}
Process {
	$Export.Token = $Key.Token | ConvertFrom-SecureString -Key $AES
	$Export.Uri = $Key.Uri
}
End {
	$Export | Export-CSV ./gcapikey.csv
}
