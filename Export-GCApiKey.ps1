Param (
	[Parameter(Mandatory=$true)][PSCustomObject]$Key,
	[Parameter(Mandatory=$true)]$AES #Path to AES key
)

$Export = [PSCustomObject]@{
	Token = ""
	Uri = $Key.Uri
}

$AES = Get-Content -Path $AES
$Export.Token = $Key.Token | ConvertFrom-SecureString -Key $AES
$Export | Export-CSV ./gcapikey.csv
