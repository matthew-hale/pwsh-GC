function Export-GCApiKey {
	
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$true)]$AES #Path to AES key

	)
	begin {
		$AES = Get-Content -Path $AES
	}
	process {
		$Export = [PSCustomObject]@{
			Token = $Key.Token | ConvertFrom-SecureString -Key $AES
			Uri = $Key.Uri
		}
	}
	end {
		$Export | Export-CSV ./gcapikey.csv
	}
}
