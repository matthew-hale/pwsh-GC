#Encapsulates the "PUT visibility/policy/rules/{ruleID}" API call

function Set-GCPolicy {
	
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][PSCustomObject]$Policy #Policy object as returned from GuardiCore, but with updated values. Accepts the PS object, not JSON data. This allows you to grab a policy, change it via powershell methods, and pass it into this function to update it.
	)
	
	$Uri = $Key.Uri + "visibility/policy/rules/" + $Policy.id
	
	$BodyJson = $Policy | ConvertTo-Json -Depth 99
	Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "PUT"
}
