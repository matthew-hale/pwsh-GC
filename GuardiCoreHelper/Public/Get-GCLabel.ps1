<#
.SYNOPSIS
	Encapsulates the "GET /visibility/labels" API call.

.DESCRIPTION
	Retrieves labels that fit the parameters given. Additionally includes member assets if find_matches is set.

.PARAMETER
	

.INPUTS
	

.OUTPUTS
	

#>
function Get-GCLabel {
	
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$false)][Switch]$FindMatches,
		[Parameter(Mandatory=$false)][System.String]$LabelKey,
		[Parameter(Mandatory=$false)][System.String]$LabelValue,
		[Parameter(Mandatory=$false)][Int32]$Limit,
		[Parameter(Mandatory=$false)][Int32]$Offset
	)
	begin {
		$Key = $global:GCApiKey
	}
	process {
		$Uri = $Key.Uri + "visibility/labels?"
		
		#Building the Uri with given parameters
		if ($FindMatches) {
			$Uri += "find_matches=true"
		} else {
			$Uri += "find_matches=false"
		}
		
		if ($LabelKey) {
			$Uri += "&key=" + $LabelKey
		}
		
		if ($LabelValue) {
			$Uri += "&value=" + $LabelValue
		}
		
		if ($Limit) {
			$Uri += "&limit=" + $Limit
		}
		
		if ($Offset) {
			$Uri += "&offset=" + $Offset
		}
	}
	end {
		Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects"
	}
}
