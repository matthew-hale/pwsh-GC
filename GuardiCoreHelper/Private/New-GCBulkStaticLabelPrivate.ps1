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
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][System.Object[]]$Labels
	)
	begin {
		$Key = $global:GCApiKey
		
		$Uri = $Key.Uri + "visibility/labels/bulk"
	}
	process {
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
		Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
	}
}