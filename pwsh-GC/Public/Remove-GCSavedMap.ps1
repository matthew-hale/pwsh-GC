# Encapsulates the "POST /visibility/saved-maps/{mapID}" API call (for deletion)

function Remove-GCSavedMap {
	
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline)]
		[PSTypeName("GCSavedMap")]$Map,

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
		
		$Result = [System.Collections.Generic.List[object]]::new()
	}
	process {
		foreach ($ThisMap in $Map) {
			$Uri = "/visibility/saved-maps/" + $ThisMap.id
			
			$Result.Add( $(pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key) )
		}
	}
	end {
		$Result
	}
}
