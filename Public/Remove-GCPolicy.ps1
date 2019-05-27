# Encapsulates the "POST visibility/policy/rules/{ruleID}" API call (for deletion)

function Remove-GCPolicy {
	
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline)]
		[System.Array]$Policy,

		[PSTypeName("GCApiKey")]
	)
	begin {
		if ( GCApiKey-present $ApiKey ) {
			if ( $ApiKey ) {
				$Key = $ApiKey
			} else {
				$Key = $global:GCApiKey
			} 
		}
		
		$Body = [PSCustomObject]@{
			action = "delete"
		}
		
		$Result = [System.Collections.Generic.List[object]]::new()
	}
	process {
		foreach ($ThisPolicy in $Policy) {
			$Uri = "/visibility/policy/rules/" + $ThisPolicy.id
			
			$Result.Add( $(pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key) )
		}
	}
	end {
		$Result
	}
}
