# Encapsulates the "PUT visibility/labels/{labelId}" API call

function Set-GCLabel {
	
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline)]
		[PSTypeName("GCLabel")]$Label 
		# Label object as returned from GuardiCore, but with updated values. Accepts the PS object, not JSON data. This allows you to grab a label, change it via powershell methods, and pass it into this function to update it.
	)
	
	begin {
		if ( GCApiKey-present $ApiKey ) {
			if ( $ApiKey ) {
				$Key = $ApiKey
			} else {
				$Key = $global:GCApiKey
			} 
		}
	}

	process {
		foreach ( $ThisLabel in $Label ) {
			$Uri = "/visibility/labels/" + $ThisLabel.id
			$RequestBody = $ThisLabel | select -ExcludeProperty id,_id

			pwsh-GC-post-request -Raw -Uri $Uri -Body $RequestBody -Method Put -ApiKey $Key
		}
	}
}
