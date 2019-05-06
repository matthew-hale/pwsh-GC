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
		[PSTypeName("GCApiKey")]$Key
	)
	begin {
		if ($global:GCApiKey) {
			$K = $global:GCApiKey
			
			$Uri = $K.Uri + "visibility/labels/bulk"
		}
	}
	process {
		if ($Key) {
			$K = $Key
			
			$Uri = $K.Uri + "visibility/labels/bulk"
		}

		if (-not $K) {
			throw "No authentication key present."
		}

		[System.Array]$LabelList += foreach ($Label in $Labels) {
			$Label
		}
		$Body = [PSCustomObject]@{
			"action" = "add"
			"labels" = $LabelList
		}
	}
	end {
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $K.Token -Body $BodyJson -Method "POST"
	}
}
