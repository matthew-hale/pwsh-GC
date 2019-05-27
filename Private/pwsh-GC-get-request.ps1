function pwsh-GC-get-request {
	[cmdletbinding()]

	param (
		[Parameter(Mandatory)]
		[String]$Uri,

		[HashTable]$Body,

		[PSTypeName("GCApiKey")]$ApiKey,

		[Switch]$Raw
	)
	
	begin {
		$Result = [System.Collections.Generic.List[object]]::new()
		if ( $ApiKey ) {
			$RequestToken = $ApiKey.Token
			$RequestUri = $ApiKey.Uri + $Uri
		} else {
			$RequestToken = $global:GCApiKey.Token
			$RequestUri = $global:GCApiKey.Uri + $Uri
		}
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
				$Result.Add($Request)
			}
	
			default {
				if ( $Request.objects ) {
					$Result.AddRange($Request.objects)
				} 
			}
		}
	}
	
	end {
		$Result
	}
}
