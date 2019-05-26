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
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)]
		[System.Object[]]$Labels,

		[Parameter(Mandatory=$false)]
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
		$LabelList = [System.Collections.Generic.List[object]]::new()
		$LabelList.AddRange($Labels)
		$Body = [PSCustomObject]@{
			"action" = "add"
			"labels" = $LabelList
		}
	}
	end {
		pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKEy $Key
	}
}
