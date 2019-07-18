function pwsh-GC-get-request {
	[cmdletbinding()]

	param (
		[Parameter(Mandatory)]
		[String]$Uri,

		[HashTable]$Body,

		[Parameter(Mandatory)]
		[PSTypeName("GCApiKey")]$ApiKey,

		[Switch]$Raw
	)
	
	begin {
		$RequestToken = $ApiKey.Token | ConvertTo-SecureString -AsPlainText -Force
		$RequestUri = $ApiKey.Uri + $Uri
	}
	
	process {
		$Request = try {
			Invoke-RestMethod -Uri $RequestUri -Method Get -Body $Body -Authentication Bearer -Token $RequestToken
		}
		catch {
			throw $_.Exception
		}
	
		switch ($Raw) {
			$true {
				$Request
			}
	
			default {
				if ( $Request.objects ) {
					$Request.objects
				} 
			}
		}
	}
}

