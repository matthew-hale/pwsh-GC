#Encapsulates the "POST /visibility/policy/revisions" API call (publishing policy)

function Publish-GCPolicy {
	
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)][System.String]$Comments,
		[Switch]$Audit
	)
	$Key = $global:GCApiKey
	
	$Uri = $Key.Uri + "visibility/policy/revisions"
	
	$Body = [PSCustomObject]@{
		action = "publish"
		comments = $Comments
	}
	
	if ($Audit) {
		$Body.comments += "`nPublished via PowerShell at: " + $(Get-Date) + " from: " + $([System.Net.Dns]::GetHostName())
	}
	
	$BodyJson = $Body | ConvertTo-Json -Depth 99
	Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
}
