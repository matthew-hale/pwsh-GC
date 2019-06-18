<#
.SYNOPSIS
	Encapsulates the "POST /visibility/labels/bulk" API call.

.DESCRIPTION
	Similar to New-GCStaticLabel, except taking an array of label objects instead of creating a single label.

.PARAMETER
	

.INPUTS
	None. This function takes no pipeline input.

.OUTPUTS
	application/json

#>
function New-GCBulkStaticLabelPrivate {
	param (
		[Parameter(ValueFromPipeline)]
		[System.Object[]]$Labels,

		[PSTypeName("GCApiKey")]$ApiKey
	)
	begin {
		if ( GCApiKey-present $ApiKey ) {
			if ( $ApiKey ) {
				$Key = $ApiKey
			} else {
				$Key = $global:GCApiKey
			} 
			$Uri = "/visibility/labels/bulk"
		}
	}
	process {
		$Body = [PSCustomObject]@{
			"action" = "add"
			"labels" = $Labels
		}

		pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
	}
}
