function pwsh-GC-post-request {
	param (
		[Parameter(Mandatory)]
		[String]$Uri,
	
		[PSTypeName("GCApiKey")]$ApiKey,

		[PSCustomObject]$Body,

		[ValidateSet("Post","Put")][String]$Method = "Post",
	
		[Switch]$Raw
	)
	
	begin {
		$Result = [System.Collections.Generic.List[object]]::new()
		if ($ApiKey) {
			$RequestToken = $ApiKey.Token
			$RequestUri = $ApiKey.Uri + $Uri
		} else {
			$RequestToken = $global:GCApiKey.Token
			$RequestUri = $global:GCApiKey.Uri + $Uri
		}
	}
	
	process {
		$Request = try {
				Invoke-RestMethod -Uri $RequestUri -Method $Method -Body $Body -ContentType "application/json" -Authentication Bearer -Token $RequestToken
			}
			catch {
				throw $_.Exception
			}
	
		switch ($Raw) {
			$true {
				$Result.Add($Request)
			}
	
			default {
				$Result.Add($Request.objects)
			}
		}
	}
	end {
		$Result
	}
}
