#Encapsulates the "POST /visibility/saved-maps/{mapID}" API call (for deletion)

function Remove-GCSavedMap {
	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][System.Array]$Map
	)
	begin {
		$Key = $Global:GCApiKey
		
		$Body = [PSCustomObject]@{
			action = "delete"
		}
		
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		
		$Result = @()
	}
	process {
		foreach ($M in $Map) {
			$Uri = $Key.Uri + "visibility/saved-maps/" + $M.id
			
			$Result += Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
		}
	}
	end {
		$Result
	}
}
