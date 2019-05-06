<#
.SYNOPSIS
	Encapsulates the "GET /visibility/labels" API call.

.DESCRIPTION
	Retrieves labels that fit the parameters given. Additionally includes member assets if find_matches is set.

.PARAMETER FindMatches
	Switch - if set to true, request returns the assets that match the label's definition.

.PARAMETER LabelKey
	The key of the label.

.PARAMETER LabelValue
	The value of the label.

.PARAMETER Limit
	The maximum number of labels to return.

.PARAMETER Offset
	The index of the first result to return.

.INPUTS
	None. This function accepts no pipeline inputs.

.OUTPUTS
	[PSTypeName="GCLabel"] One or more GCLabel objects.

#>
function Get-GCLabel {
	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)]
		[Switch]$FindMatches,

		[Parameter(Mandatory=$false)]
		[System.String]$LabelKey,

		[Parameter(Mandatory=$false)]
		[System.String]$LabelValue,

		[Parameter(Mandatory=$false)]
		[ValidateRange(0,1000)][Int32]$Limit,

		[Parameter(Mandatory=$false)]
		[ValidateRange(0,500000)][Int32]$Offset,

		[Parameter(Mandatory=$false)]
		[PSTypeName("GCApiKey")]$Key
	)
	begin {
		if ($global:GCApiKey) {
			$K = $global:GCApiKey
			$Uri = $K.Uri + "visibility/labels?"
		} elseif ($Key) {
			$K = $Key
			$Uri = $K.Uri + "visibility/labels?"
		} else {
			throw "No authentication key present."
		}
		
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
	process {
		try {
			$Result = $(Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $K.Token -Method "GET" | Select-Object -ExpandProperty "objects") | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCLabel"); $_}
		}
		catch {
			throw $_.Exception
		}
	}
	end {
		$Result
	}
}
