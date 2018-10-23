Function ConvertFrom-GCUnixTime {

<#
Converts a given Unix timestamp in milliseconds to a System.DateTime object in UTC
#>
	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][Long]$UnixDate
	)
	Process {
		[System.DateTime]$Origin = '1970-01-01 00:00:00'
		$Origin = $Origin.ToUniversalTime()
		$Converted = $Origin.AddSeconds($UnixDate/1000) #Remember: GuardiCore works with epoch times in milliseconds
	}
	End {
		Return $Converted
	}
} #End ConvertFrom-UnixTime

Function ConvertTo-GCUnixTime {

<#
Converts a given UTC DateTime object to Unix time in milliseconds
#>

	[cmdletbinding()]
	Param (
		
	)
	Process {
		
	}
	End {
		
	}
} #End ConvertTo-UnixTime

Function Set-GCHeaders {

<#
Returns correctly formatted authentication header within a headers object for GET requests given an auth token input;
contains a Post switch that appends "Content-Type","application/json" to the headers for post requests
#>

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][String]$Token,
		[Switch]$Post
	)
	Process {
		$Headers = New-Object 'System.Collections.Generic.Dictionary[String,String]'
		$Headers.add("Authorization","bearer " + $Token)
		
		if ($Post) {
			$Headers.add("Content-Type","application/json")
		}
	}
	End {
		Return $Headers
	}
} #End Set-Headers

Function Get-GCAPIKey {

<#
Gets and parses an API key from the specified server using the given credentials
#>

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][String]$Server
	)
	Begin {
		$Uri = "https://" + $Server + ".cloud.guardicore.com/api/v3.0/authenticate"
		$Credentials = Get-Credential
		$Body = '{"username": "' + $Credentials.UserName + '", "password": "' + $Credentials.GetNetworkCredential().Password + '"}'
		$Headers = New-Object 'System.Collections.Generic.Dictionary[String,String]'
		$Headers.add("Content-Type","application/json")
	}
	Process {
		$OutRaw = Invoke-WebRequest -UseBasicParsing -Uri $Uri -Method 'Post' -Body $Body -Headers $Headers
		if ($OutRaw.StatusCode -ne 200) {
			Return "Something broke"
		}
		$Output = $OutRaw.Content | ConvertFrom-JSON
	}
	End {
		Return $Output
	}
} #End Get-APIKey

Function Get-GCNetworkLog {

<#
Makes an API call to download a csv file of the network log of a management server
(via the API key generated from the Get-APIKey function);
note that times are in Unix format, in milliseconds (use the ConvertTo-UnixTime function beforehand)
#>

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][System.Array]$Logs,
		[Parameter(Mandatory=$true)][String]$StartTime,
		[Parameter(Mandatory=$true)][String]$EndTime
	)
	Begin {
		$Uri = "https://" + $Server + ".cloud.guardicore.com/api/v3.0/connections/"
	}
	Process {
		
	}
	End {
		
	}
} #End Get-NetworkLog

Function Get-GCFlowTotal {

<#
Each flow has a "count" field that increments whenever an identical flow is recorded;
to obtain the true total number of flows for a given set of flow objects, we need to increment a separate counter by these "count" fields;
this function does that
#>

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][System.Array]$Connections
	)
	
	Begin {
		$Subtotal = 0
	}
	Process {
		foreach ($Flow in $Connections) {
			$Subtotal += $Flow.count
		}
	}
	End {
		$Total = $Subtotal
		Return $Total
	}
} #End Get-FlowTotal