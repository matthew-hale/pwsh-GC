<#
.SYNOPSIS
	Returns an API key from the specified GuardiCore management server using the given credentials.

.DESCRIPTION
	To make GuardiCore API calls, an API key must be included in the headers. Thus, this first API call must be made; it returns a token that can be used for further API calls. The token represents a user session, and has the same timeout duration.

.PARAMETER Server
	[System.String] GuardiCore management server, in the format: "cus-5555".

.PARAMETER Credentials
	[PSCredential] API user credentials.

.INPUTS
	[PSCredential] $Credentials parameter.

.OUTPUTS
	[PSCustomObject] Key containing a token and the base Uri for further API calls.

#>
function Get-GCApiKey {

	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)][System.String]$Server,
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCredential]$Credentials
	)
	begin {
		$Uri = "https://" + $Server + ".cloud.guardicore.com/api/v3.0/"
		$TempUri = $Uri + "authenticate"
		$Body = [PSCustomObject]@{
			"username" = ""
			"password" = ""
		}
	}
	process {
		$Body.username = $Credentials.UserName
		$Body.password = $Credentials.GetNetworkCredential().Password
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		$Token = Invoke-RestMethod -Uri $TempUri -Method "POST" -Body $BodyJson -ContentType "application/json" | Select-Object -ExpandProperty "access_token" | ConvertTo-SecureString -AsPlainText -Force
	}
	end {
		$Key = [PSCustomObject]@{
			Token = $Token
			Uri = $Uri
		}
		$Key
	}
}
