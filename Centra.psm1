<#
.SYNOPSIS
	Converts a given Unix timestamp in milliseconds to a System.DateTime object in local time.
	
.DESCRIPTION
	GuardiCore uses Unix time in milliseconds for most timestamps in the API. This funciton, and its sister function ConvertTo-GCUnixTime, allow conversion to/from timestamps (System.DateTime objects) and Unix timestamps (in milliseconds).
	
.PARAMETER UnixDate
	[Long] Unix timestamp in milliseconds.
	
.INPUTS
	[Int64] $UnixDate parameter.
	
.OUTPUTS
	[DateTime]
	
#>
Function ConvertFrom-GCUnixTime {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][Int64]$UnixDate
	)
	Process {
		$Origin = New-Object DateTime 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc)
		$Converted = $Origin.AddSeconds([Int]($UnixDate/1000)) #Remember: GuardiCore works with epoch times in milliseconds
	}
	End {
		$Converted.ToLocalTime()
	}
}


<#
.SYNOPSIS
	Converts a given System.DateTime object to a Unix timestamp in milliseconds.

.DESCRIPTION
	GuardiCore uses Unix time in milliseconds for most timestamps in the API. This funciton, and its sister function ConvertFrom-GCUnixTime, allow conversion to/from timestamps (System.DateTime objects) and Unix timestamps (in milliseconds).

.PARAMETER DateTime
	[DateTime] The timestamp you wish to convert to Unix time in milliseconds.

.INPUTS
	[DateTime] $DateTime parameter.

.OUTPUTS
	[Int64] Unix timestamp in milliseconds.

#>
Function ConvertTo-GCUnixTime {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][DateTime]$DateTime
	)
	Process {
		$Origin = New-Object DateTime 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc)
		[Int64]$Converted = ($DateTime.ToUniversalTime()-$Origin).TotalMilliseconds
	}
	End {
		$Converted
	}
}


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
Function Get-GCApiKey {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true)][System.String]$Server,
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCredential]$Credentials
	)
	Begin {
		$Uri = "https://" + $Server + ".cloud.guardicore.com/api/v3.0/"
		$TempUri = $Uri + "authenticate"
		$Body = [PSCustomObject]@{
			"username" = ""
			"password" = ""
		}
	}
	Process {
		$Body.username = $Credentials.UserName
		$Body.password = $Credentials.GetNetworkCredential().Password
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		$Token = Invoke-RestMethod -Uri $TempUri -Method 'Post' -Body $BodyJson -ContentType "application/json" | Select-Object -ExpandProperty "access_token" | ConvertTo-SecureString -AsPlainText -Force
	}
	End {
		$Key = [PSCustomObject]@{
			Token = $Token
			Uri = $Uri
		}
		$Key
	}
}


<#
.SYNOPSIS
	Returns the total number of connections in a given array of GuardiCore flow objects.

.DESCRIPTION
	Each flow has a "count" field that increments whenever an identical flow is recorded. To obtain the true total number of connections for a given set of flow objects, this function sums each individual count field.

.PARAMETER Flows
	[System.Array] GuardiCore flow objects.

.INPUTS
	[System.Array] $Flows parameter.

.OUTPUTS
	[Int32] Total count.

#>
Function Get-GCTotalCount {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][System.Array]$Flows
	)
	
	Begin {
		$Subtotal = 0
	}
	Process {
		$SubTotal += foreach ($Flow in $Flows) {
			$Flow.Count
		}
	}
	End {
		[Int32]$Subtotal
	}
}


<#
.SYNOPSIS
	Encapsulates the "GET /assets" API call.

.DESCRIPTION
	Searches can be based on hostname, domain name, IP, etc. Note that if seraching by IP, GuardiCore's search may return more assets than the one with the specific IP given. An example of this is a search for "10.0.0.1" returning assets with IPs "10.0.0.12", "10.0.0.100", and "10.0.0.1". Additional parsing may be required.

.PARAMETER Search
	[System.String] A generic search string.

.PARAMETER Status
	[System.String] Status of the asset; accepts "on" or "off".

.PARAMETER Risk
	[Int32] Risk level, from 0 to 3.

.PARAMETER Limit
	[Int32] Max number of results returned.

.PARAMETER Offset
	[Int32] Position of beginning of result range.

.PARAMETER Key
	[PSCustomObject] GuardiCore API key.

.INPUTS
	[System.String] $Search parameter

.OUTPUTS
	[System.Array] Asset objects
#>
Function Get-GCAsset {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][System.String]$Search,
		[Parameter(Mandatory=$false)][ValidateSet("on","off")][System.String]$Status,
		[Parameter(Mandatory=$false)][ValidateRange(0,3)][Int32]$Risk,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Limit,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Offset
	)
	Begin {
		$Uri = $Key.Uri + "assets?"
		
		#Building the Uri with given parameters
		If ($Status) {
			$Uri += "status=" + $Status + "&"
		}
		
		If ($Risk) {
			$Uri += "risk=" + $Risk + "&"
		}
		
		If ($Limit) {
			$Uri += "limit=" + $Limit + "&"
		}
		
		If ($Offset) {
			$Uri += "offset=" + $Offset
		}
	}
	Process {
		#Building the Uri with given pipeline parameters
		If ($Search) {
			$Uri += "&search=" + $Search
		}
	}
	End {
		Invoke-RestMethod -Authentication Bearer -Token $Key.Token -Uri $Uri -Method "GET" | Select-Object -ExpandProperty "objects"
	}
}


<#
.SYNOPSIS
	Encapsulates the "GET /agents" API call.

.DESCRIPTION
	Gets one or more agents based on the given parameters/filters.

.PARAMETER
	

.INPUTS
	None. This function takes no pipeline input.

.OUTPUTS
	[System.Array] Agent objects.

#>
Function Get-GCAgent {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false)][System.String]$Version,
		[Parameter(Mandatory=$false)][System.String]$Kernel,
		[Parameter(Mandatory=$false)][ValidateSet("Unknown","Windows","Linux")][System.String]$OS,
		[Parameter(Mandatory=$false)][System.String]$Labels,
		[Parameter(Mandatory=$false)][ValidateSet("Online","Offline")][System.String]$Status, # = display_status
		[Parameter(Mandatory=$false)][ValidateRange(1,14)][Int32]$Flags,
		[Parameter(Mandatory=$false)][ValidateSet("Active","Not Deployed","Disabled")][System.String]$Enforcement, # = module_status_enforcement
		[Parameter(Mandatory=$false)][ValidateSet("Active","Not Deployed")][System.String]$Deception, # = module_status_deception
		[Parameter(Mandatory=$false)][ValidateSet("Active","Not Deployed")][System.String]$Detection, # = module_status_detection
		[Parameter(Mandatory=$false)][ValidateSet("Active","Not Deployed")][System.String]$Reveal,  # = module_status_reveal
		[Parameter(Mandatory=$false)][ValidateSet("last_month","last_week","last_12_hours","last_24_hours","not_active")][System.String]$Activity,
		[Parameter(Mandatory=$false)][System.String]$GcFilter,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Limit,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Offset
	)
	Begin {
		$Uri = $Key.Uri + "agents?"
		
		#Building the Uri with given parameters
		If ($Version) {
			$Uri += "version=" + $Version + "&"
		}
		
		If ($Kernel) {
			$Uri += "kernel=" + $Kernel + "&"
		}
		
		If ($OS) {
			$Uri += "os=" + $OS + "&"
		}
		
		If ($Labels) {
			$Uri += "labels=" + $Labels + "&"
		}
		
		If ($Status) {
			$Uri += "display_status="
			If ($Status -eq "Disabled") {
				$Uri += "Enforcement disabled from management console&"
			} else {
				$Uri += $Status + "&"
			}
		}
		
		If ($Flags) {
			$Uri += "status_flags=" + $Flags + "&"
		}
		
		If ($Enforcement) {
			$Uri += "module_status_enforcement=" + $Enforcement + "&"
		}
		
		If ($Deception) {
			$Uri += "module_status_deception=" + $Deception + "&"
		}
		
		If ($Detection) {
			$Uri += "module_status_detection=" + $Detection + "&"
		}
		
		If ($Reveal) {
			$Uri += "module_status_reveal=" + $Reveal + "&"
		}
		
		If ($Activity) {
			$Uri += "activity=" + $Activity + "&"
		}
		
		If ($GcFilter) {
			$Uri += "gc_filter=" + $GcFilter + "&"
		}
		
		If ($Limit) {
			$Uri += "limit=" + $Limit + "&"
		}
		
		If ($Offset) {
			$Uri += "offset=" + $Offset
		}
	}
	Process {
		$Agents = Invoke-RestMethod -Authentication Bearer -Token $Key.Token -Uri $Uri -Method "GET" | Select-Object -ExpandProperty "objects"
	}
	End {
		$Agents
	}
}


<#
.SYNOPSIS
	Encapsulates the "POST /visibility/labels/bulk" API call.

.DESCRIPTION
	Similar to New-GCStaticLabel, except taking an array of label objects instead of creating a single label.

.PARAMETER
	

.INPUTS
	[System.Array] $Labels parameter.

.OUTPUTS
	application/json

#>
Function New-GCBulkLabel {
	Param (
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][System.Array]$Labels
	)
	Begin {
		$Uri = $Key.Uri + "visibility/labels/bulk"
		
		$Body = [PSCustomObject]@{
			"action" = "add"
			"labels" = @()
		}
	}
	Process {
		$Body.labels += foreach ($Label in $Labels) {
			$Label
		}
	}
	End {
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		Invoke-RestMethod -Authentication Bearer -Token $Key.Token -Uri $Uri -Method "POST" -Body $BodyJson -ContentType "application/json"
	}
}


<#
.SYNOPSIS
	Encapsulates the "POST /assets/labels/{key}/{value}" API call.

.DESCRIPTION
	Creates a static label with given VMs, specified by unique ID. If the given Key/Value pair already exists, the new VMs are appended to the existing label.

.PARAMETER Key
	[PSCustomObject] GuardiCore api key.

.PARAMETER Assets
	[System.Array] Array of GuardiCore asset IDs. Used for static label definitions.

.PARAMETER LabelKey
	[System.String] Key of the label to be updated. Required for both dynamic and static labels.

.PARAMETER LabelValue
	[System.String] Value of the label to be updated. Required for both dynamic and static labels.

.INPUTS
	[System.Array] $Assets parameter.

.OUTPUTS
	application/json

#>
Function New-GCStaticLabel {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)][System.Array]$Assets,
		[Parameter(Mandatory=$true)][System.String]$LabelKey,
		[Parameter(Mandatory=$true)][System.String]$LabelValue
	)
	Begin {
		$Uri = $Key.Uri + "assets/labels/" + $LabelKey + "/" + $LabelValue
		$Body = [PSCustomObject]@{
			"vms" = @()
		}
	}
	Process {
		$Body.vms += foreach ($Asset in $Assets) {
			$Asset
		}
	}
	End {
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
	}
}
