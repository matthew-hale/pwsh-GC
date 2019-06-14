#Encapsulates the "DELETE visibility/labels/{labelid}" API call (for deletion)

function Remove-GCLabel {
	
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline)]
		[PSTypeName("GCLabel")]$Label,

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

		$Result = [System.Collections.Generic.List[object]]::new()
	}
	process {
		foreach ($ThisLabel in $Label) {
			$Uri = "/visibility/labels/" + $ThisLabel.id
			pwsh-GC-delete-request -Uri $Uri -ApiKey $Key
		}
	}
	end {
		$Result
	}
}
