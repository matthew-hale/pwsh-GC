#Encapsulates the "DELETE visibility/labels/{labelid}" API call (for deletion)

function Remove-GCLabel {
	
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][PSCustomObject]$Label
	)
	begin {
		$Result = @()
	}
	process {
		$Result += foreach ($L in $Label) {
			$Uri = $Key.Uri + "visibility/labels/" + $L.id
			Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "DELETE"
		}
	}
	end {
		$Result
	}
}
