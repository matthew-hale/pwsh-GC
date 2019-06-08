function pwsh-GC-post-request {
	param (
		[Parameter(Mandatory)]
		[String]$Uri,
	
		[PSCustomObject]$Body,

		[Parameter(Mandatory)]
		[PSTypeName("GCApiKey")]$ApiKey,

		[ValidateSet("Post","Put")][String]$Method = "Post",
	
		[Switch]$Raw
	)
	
	$Result = [System.Collections.Generic.List[object]]::new()

	$RequestToken = $ApiKey.Token
	$RequestUri = $ApiKey.Uri + $Uri
	$RequestBody = $Body | ConvertTo-Json -Depth 10

	$Request = try {
		Invoke-RestMethod -Uri $RequestUri -Method $Method -Body $RequestBody -ContentType "application/json" -Authentication Bearer -Token $RequestToken
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

	$Result
}
