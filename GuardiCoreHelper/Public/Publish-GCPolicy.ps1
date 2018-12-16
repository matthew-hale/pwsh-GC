#Encapsulates the "POST /visibility/policy/revisions" API call (publishing policy)

function Publish-GCPolicy {
	
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$true)][System.String]$Comments
	)
	
	$Uri = $Key.Uri + "visibility/policy/revisions"
	
	$Body = [PSCustomObject]@{
		action = "publish"
		comments = $Comments
	}
	
	$BodyJson = $Body | ConvertTo-Json -Depth 99
	Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
}
