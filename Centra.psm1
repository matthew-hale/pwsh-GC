<#
.SYNOPSIS
	Converts a given Unix timestamp in milliseconds to a System.DateTime object in UTC.
	
.DESCRIPTION
	GuardiCore uses Unix time in milliseconds for most timestamps in the API. This funciton, and its sister function ConvertTo-GCUnixTime, allow conversion to/from UTC timestamps (System.DateTime objects) and Unix timestamps (in milliseconds).
	
.PARAMETER UnixDate
	[Long] Unix timestamp in milliseconds.
	
.INPUT
	Long (Parameter: UnixDate)
	
.OUTPUT
	System.DateTime
	
#>
Function ConvertFrom-GCUnixTime {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="UnixDate")][Int64]$UnixDate
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


<#
.SYNOPSIS
	Converts a given System.DateTime object in UTC to a Unix timestamp in milliseconds.

.DESCRIPTION
	GuardiCore uses Unix time in milliseconds for most timestamps in the API. This funciton, and its sister function ConvertFrom-GCUnixTime, allow conversion to/from UTC timestamps (System.DateTime objects) and Unix timestamps (in milliseconds).

.PARAMETER
	

.INPUT
	

.OUTPUT
	

#>
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


<#
.SYNOPSIS
	

.DESCRIPTION
	

.PARAMETER
	

.INPUT
	

.OUTPUT
	

#>
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


<#
.SYNOPSIS
	Returns an API key from the specified GuardiCore management server using the given credentials.

.DESCRIPTION
	To make GuardiCore API calls, an API key must be included in the headers. Thus, this first API call must be made; it returns a token that can be used for further API calls. The token represents a user session, and has the same timeout duration.

.PARAMETER Server
	[System.String] Management server, in the format: "cus-5555"

.INPUT
	

.OUTPUT
	

#>
Function Get-GCAPIKey {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][System.String]$Server
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
		Return $Output.access_token
	}
} #End Get-APIKey


<#
.SYNOPSIS
	

.DESCRIPTION
	

.PARAMETER
	

.INPUT
	

.OUTPUT
	

#>
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


<#
.SYNOPSIS
	Returns the total number of connections in a given array of GuardiCore flow objects.

.DESCRIPTION
	Each flow has a "count" field that increments whenever an identical flow is recorded. To obtain the true total number of connections for a given set of flow objects, this function sums each individual count field.

.PARAMETER Flows
	[System.Array] GuardiCore flows.

.INPUT
	System.Array (Parameter: Flows)

.OUTPUT
	System.Int32

#>
Function Get-GCFlowTotal {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][System.Array]$Flows
	)
	
	Begin {
		$Subtotal = 0
	}
	Process {
		foreach ($Flow in $Flows) {
			$Subtotal += $Flow.count
		}
	}
	End {
		[Int32]$Total = $Subtotal
		Return $Total
	}
} #End Get-FlowTotal