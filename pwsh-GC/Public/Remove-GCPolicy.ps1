# Encapsulates the "POST visibility/policy/rules/{ruleID}" API call (for deletion)

function Remove-GCPolicy {
	
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline)]
		[System.Array]$Policy,

		[PSTypeName("GCApiKey")]$ApiKey
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
	}
	process {
		foreach ($ThisPolicy in $Policy) {
			$Uri = "/visibility/policy/rules/" + $ThisPolicy.id
			
			pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
		}
	}
}
