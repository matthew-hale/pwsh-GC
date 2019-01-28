<#
.SYNOPSIS
	Authenticates with the given management server, and stores a key in a global variable called "GCApiKey"

.DESCRIPTION
	To make GuardiCore API calls, an API token must be included in the headers. Thus, this first API call must be made; it returns a token that can be used for further API calls. The token represents a user session, and has the same timeout duration. The GCApiKey variable includes this token, plus the Uri of the management server that it's authenticated with. All functions in the module that use this token are able to get the Uri and the token from this variable without further user input.

.PARAMETER Server
	[System.String] GuardiCore management server, in the format: "cus-5555".

.PARAMETER Credentials
	[PSCredential] API user credentials.

.INPUTS
	[PSCredential] $Credentials parameter.

.OUTPUTS
	None. This function has no pipeline output.

#>
function Get-GCApiKey {

	[CmdletBinding()]
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
		try {
			$Token = Invoke-RestMethod -Uri $TempUri -Method "POST" -Body $BodyJson -ContentType "application/json" | Select-Object -ExpandProperty "access_token" | ConvertTo-SecureString -AsPlainText -Force
		}
		catch {
			throw $_.Exception
		}
	}
	end {
		$Global:GCApiKey = [PSCustomObject]@{ #Saves the object in a global (session scope) variable called GCApiKey, so other functions don't need a key input.
			PSTypeName = "GCApiKey"
			Token = $Token
			Uri = $Uri
		}
	}
}
