#Encapsulates the "POST visibility/policy/rules/{ruleID}" API call (for deletion)

function Remove-GCPolicy {
	
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][System.Array]$Policy
	)
	begin {
		$Key = $global:GCApiKey
		
		$Body = [PSCustomObject]@{
			action = "delete"
		}
		
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		
		$Result = @()
	}
	process {
		foreach ($P in $Policy) {
			$Uri = $Key.Uri + "visibility/policy/rules/" + $P.id
			
			$Result += Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
		}
	}
	end {
		$Result
	}
}
