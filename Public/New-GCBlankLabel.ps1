function New-GCBlankLabel {
	[cmdletbinding()]

	param (
		[Parameter(Mandatory=$true)]$LabelKey,
		[Parameter(Mandatory=$true)]$LabelValue
	)
	$Uri = $Global:GCApiKey.Uri + "visibility/labels"
	$Token = $Global:GCApiKey.Token

	$Body = [PSCustomObject]@{
		id = $null
		key = $LabelKey
		value = $LabelValue
		criteria = @()
	}

	$BodyJson = $Body | ConvertTo-Json

	Invoke-RestMethod -Uri $Uri -Method POST -ContentType application/json -Authentication Bearer -Token $Token -Body $BodyJson
}
