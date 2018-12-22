#Encapsulates the "POST visibility/policy/rules/{ruleID}" API call (for deletion)

function Remove-GCPolicy {
	
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false)][System.String]$PolicyID
	)
	
	$Uri = $Key.Uri + "visibility/policy/rules/" + $PolicyID
	
	$Body = [PSCustomObject]@{
		action = "delete"
	}
	
	$BodyJson = $Body | ConvertTo-Json -Depth 99
	Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
}
