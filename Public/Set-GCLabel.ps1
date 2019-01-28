#Encapsulates the "PUT visibility/labels/{labelId}" API call

function Set-GCLabel {
	
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][PSCustomObject]$Label #Label object as returned from GuardiCore, but with updated values. Accepts the PS object, not JSON data. This allows you to grab a label, change it via powershell methods, and pass it into this function to update it.
	)
	$Key = $global:GCApiKey
	
	$Uri = $Key.Uri + "visibility/labels/" + $Label.id
	
	$BodyJson = $Label | select -ExcludeProperty id,_id | ConvertTo-Json -Depth 99
	Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "PUT"
}
