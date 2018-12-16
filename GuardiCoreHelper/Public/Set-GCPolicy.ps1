#Encapsulates the "PUT visibility/policy/rules/{ruleID}" API call

function Set-GCPolicy {
	
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false)][PSCustomObject]$Policy #Policy object as returned from GuardiCore, but with updated values
	)
	
	$Uri = $Key.Uri + "visibility/policy/rules/" + $Policy.id
	
	$BodyJson = $Policy | ConvertTo-Json -Depth 99
	Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
}
