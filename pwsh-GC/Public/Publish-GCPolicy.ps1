# Encapsulates the "POST /visibility/policy/revisions" API call (publishing policy)

function Publish-GCPolicy {
	
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[System.String]$Comments,

		[Switch]$Audit,

		[PSTypeName("GCApiKey")]$ApiKey
	)

	if ( GCApiKey-present $ApiKey ) {
		if ( $ApiKey ) {
			$Key = $ApiKey
		} else {
			$Key = $global:GCApiKey
		} 
		$Uri = "/visibility/policy/revisions"
	}
	
	# Building the request body from parameters

	$Body = [PSCustomObject]@{
		action = "publish"
		comments = $Comments
	}
	
	if ($Audit.IsPresent) {
		$Body.comments += "`nPublished via pwsh-GC at: " + $(Get-Date) + " from: " + $([System.Net.Dns]::GetHostName()) + " (" + (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content + ")"
	}
	
	pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
}
