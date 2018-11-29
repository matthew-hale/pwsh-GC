<#
.SYNOPSIS
	Converts a given Unix timestamp in milliseconds to a System.DateTime object in local time.
	
.DESCRIPTION
	GuardiCore uses Unix time in milliseconds for most timestamps in the API. This funciton, and its sister function ConvertTo-GCUnixTime, allow conversion to/from timestamps (System.DateTime objects) and Unix timestamps (in milliseconds).
	
.PARAMETER UnixDate
	[Long] Unix timestamp in milliseconds.
	
.INPUTS
	System.Int64 (Parameter: UnixDate)
	
.OUTPUTS
	System.DateTime
	
#>
Function ConvertFrom-GCUnixTime {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][Int64]$UnixDate
	)
	Process {
		$Origin = New-Object DateTime 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc)
		$Converted = $Origin.AddSeconds($UnixDate/1000) #Remember: GuardiCore works with epoch times in milliseconds
	}
	End {
		Return $Converted.ToLocalTime()
	}
}


<#
.SYNOPSIS
	Converts a given System.DateTime object to a Unix timestamp in milliseconds.

.DESCRIPTION
	GuardiCore uses Unix time in milliseconds for most timestamps in the API. This funciton, and its sister function ConvertFrom-GCUnixTime, allow conversion to/from timestamps (System.DateTime objects) and Unix timestamps (in milliseconds).

.PARAMETER
	

.INPUTS
	

.OUTPUTS
	

#>
Function ConvertTo-GCUnixTime {

	[cmdletbinding()]
	Param (
		
	)
	Process {
		
	}
	End {
		
	}
}


<#
.SYNOPSIS
	

.DESCRIPTION
	

.PARAMETER
	

.INPUTS
	

.OUTPUTS
	

#>
Function Set-GCHeaders {

<#
Returns correctly formatted authentication header within a headers object for API requests given an auth token input
#>

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][String]$Token
	)
	Process {
		$Headers = New-Object 'System.Collections.Generic.Dictionary[String,String]'
		$Headers.add("Authorization","bearer " + $Token)
		$Headers.add("Content-Type","application/json")
	}
	End {
		Return $Headers
	}
}


<#
.SYNOPSIS
	Returns an API key from the specified GuardiCore management server using the given credentials.

.DESCRIPTION
	To make GuardiCore API calls, an API key must be included in the headers. Thus, this first API call must be made; it returns a token that can be used for further API calls. The token represents a user session, and has the same timeout duration.

.PARAMETER Server
	[System.String] GuardiCore management server, in the format: "cus-5555".

.INPUTS
	System.String

.OUTPUTS
	System.String

#>
Function Get-GCAPIKey {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][System.String]$Server
	)
	Begin {
		$Uri = "https://" + $Server + ".cloud.guardicore.com/api/v3.0/"
		$TempUri = $Uri + "authenticate"
		$Credentials = Get-Credential
		$Body = '{"username": "' + $Credentials.UserName + '", "password": "' + $Credentials.GetNetworkCredential().Password + '"}'
		
		#Custom header generation, as this is the only API call that doesn't require a token
		$Headers = New-Object 'System.Collections.Generic.Dictionary[String,String]'
		$Headers.add("Content-Type","application/json")
	}
	Process {
		$OutRaw = Invoke-WebRequest -UseBasicParsing -Uri $TempUri -Method 'Post' -Body $Body -Headers $Headers
		if ($OutRaw.StatusCode -ne 200) {
			Return $OutRaw
		}
		$Output = $OutRaw.Content | ConvertFrom-JSON
	}
	End {
		$Token = $Output.access_token
		$Key = [PSCustomObject]@{
			Token = $Token
			Uri = $Uri
		}
		
		$Key
	}
}


<#
.SYNOPSIS
	Gets a list of raw flows from the management server.

.DESCRIPTION
	Makes an API call to download a csv file of the network log of a management server (via the API key generated from the Get-APIKey function); note that times are in Unix format, in milliseconds (use the ConvertTo-UnixTime function beforehand).

.PARAMETER StartTime
	[System.Int64] Defines the start of the window of flows. Unix time in miliseconds.

.PARAMETER EndTime
	[System.Int64] Defines the end of the window of flows. Unix time in miliseconds.

.PARAMETER Key
	[PSCustomObject] GuardiCore API Key.

.PARAMETER OutPath
	[System.IO.FileInfo] Destination directory for the generated csv files. Note the potential for many files to be generated.

.INPUTS
	None. This function takes no pipeline INPUTS

.OUTPUTS
	CSV file(s)

#>
Function Get-GCNetworkFlows {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$false)][System.Int64]$StartTime,
		[Parameter(Mandatory=$false)][System.Int64]$EndTime,
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$true)][ValidateScript({
			If (-Not ($_ | Test-Path)) {
                throw "Specified OutPath does not exist." 
            }
			If (-Not ($_ | Test-Path -PathType Container)) {
				throw "OutPath must be to a folder. Direct file paths are not allowed."
			}
		})][System.IO.FileInfo]$OutPath
	)
	Begin {
		$Headers = Set-GCHeaders -Token $Key.Token
		
		#Default values for start and end times are one hour ago, and now
		If (-Not ($StartTime)) {
			
		}
		
		If (-Not $EndTime) {
			
		}
		
		$Uri = "https://" + $Server + ".cloud.guardicore.com/api/v3.0/connections?sort=-slot_start_time"
		
		#Ensure the path has a trailing backslash
		$C = "\"
		If ($OutPath[-1] -ne $C) {$OutPath += $C}
		
		#The API can only index objects up to 500000; after that it just doesn't return anything except a 500 server error
		#This means our strategy of breaking up larger timeframes into chunks via offset values doesn't work
		#Instead we need to do it via timestamp changes AND offset values (offset values for timeouts, timestamp changes due to guardicore limitations)
		#The problem is that we cannot guarantee a new time range is less than 500000 flows without validating mathematically with more API calls
		#What we CAN do is break up the time range into chunks that are VIRTUALLY guaranteed to contain less than 500000 flows—say, hourly
		
		#First, we make a single API call to see how many flows fall within our time frame, for logging purposes
		$TempUri = $Uri + "&from_time=" + $StartTime + "&to_time=" + $EndTime
		$TotalCount = Invoke-WebRequest -Uri $Uri -Method "GET" -Headers $Headers -UseBasicParsing | ConvertFrom-Json | Select-Object -ExpandProperty "total_count"
		
		#Chunk the time range into hourly chunks, if the range itself is more than 1 hour
		$HourInMilliseconds = 3600000
		$TimeRange = $EndTime - $StartTime
		If ($TimeRange -gt $HourInMilliseconds) {
			$Chunks = [Int32]($TimeRange / $HourInMilliseconds)
			If ($TimeRange % $HourInMilliseconds -ne 0) { #If there is a remainder, run an extra chunk to get what's left
				$Chunks++
			}
		} else {
			$Chunks = 1
		}
		
		#Static
		$Limit = 10000
		
		#OutFile counter
		$Counter = 1
		
		$TempStartTime = $StartTime
		$TempEndTime = $TempStartTime + $HourInMilliseconds - 1
	}
	Process {
		For ($j = 0; $j -lt $Chunks; $j++) { #This loop iterates through chunks of time
			$Offset = 0
			
			For ($i = 0; $i -lt 50; $i++) { #This loop makes the API calls, 10000 at a time, up to 500000 (hard maximum)
				$TempUri = $Uri + "&from_time=" + $TempStartTime + "&to_time=" + $TempEndTime+ "&offset=" + $Offset + "&limit=" + $Limit
				$Output = Invoke-WebRequest -UseBasicParsing -Uri $TempUri -Headers $Headers | ConvertFrom-Json | Select-Object -ExpandProperty "objects"
				
				If ($Output.total_count -eq 0) { #If the most recent API call is empty, this chunk is done, so break
					break
				} else { #If it's not empty, export the data and increment offset and counter
					$TempOutPath = $OutPath + $Counter + ".csv"
					$Output | Export-CSV -NoTypeInformation -Path $TempOutPath
					$Offset += 10000
					$Counter++	
				}				
			}
			
			#Calculating this chunk's new start and end time
			$TempStartTime = $TempEndTime + 1
			$TempEndTime = $TempEndTime + $HourInMilliseconds - 1
		}
	}
	End {
		
	}
}


<#
.SYNOPSIS
	Returns the total number of connections in a given array of GuardiCore flow objects.

.DESCRIPTION
	Each flow has a "count" field that increments whenever an identical flow is recorded. To obtain the true total number of connections for a given set of flow objects, this function sums each individual count field.

.PARAMETER Flows
	[System.Array] GuardiCore flows.

.INPUTS
	System.Array (Parameter: Flows)

.OUTPUTS
	System.Int32

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
		foreach ($Flow in $Flows) {
			$Subtotal += $Flow.count
		}
	}
	End {
		[Int32]$Total = $Subtotal
		Return $Total
	}
}


<#
.SYNOPSIS
	Gets the GuardiCore asset(s) that matches the given search parameters.

.DESCRIPTION
	Searches can be based on hostname, domain name, IP, etc. Note that GuardiCore's search may return more assets than the one with the specific IP. An example of this is a search for "10.0.0.1" returning assets with IPs "10.0.0.12", "10.0.0.100", and "10.0.0.1". Additional parsing may be required.

.PARAMETER Search
	[System.String] A generic search string.

.PARAMETER Key
	[PSCustomObject] GuardiCore API key.

.INPUTS
	None. This script has no pipeline input.

.OUTPUTS
	System.Array of Asset objects
#>
Function Get-GCAsset {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true)][System.String]$Search,
		[Parameter(Mandatory=$true)][PSCustomObject]$Key
	)
	Begin {
		$Headers = Set-GCHeaders -Token $Key.Token
		$Uri = $Key.Uri + "assets?search=" + $Search + "&offset=0&limit=100"
	}
	Process {
		$Assets = Invoke-WebRequest -UseBasicParsing -Headers $Headers -Uri $Uri -Method "GET" | ConvertFrom-Json | Select-Object -ExpandProperty "objects"
	}
	End {
		$Assets
	}
}


<#
.SYNOPSIS
	Sets a given label's dynamic or static definition. Default is static.

.DESCRIPTION
	Caution must be used when changing dynamic labels with this function, as it does not append to, but overwrites, the current definition. Static labels require a key and a value, while dynamic labels require a key, a value, and a unique ID.

.PARAMETER Dynamic
	[Switch] Specifies that the label to be set is dynamic, and will thus have much different parameters than a static label definition.

.PARAMETER Key
	[PSCustomObject] GuardiCore api key.

.PARAMETER Assets
	[System.Array] Array of GuardiCore asset IDs. Used for static label definitions.

.PARAMETER LabelId
	[System.String] ID of the dynamic label to be updated.

.PARAMETER LabelKey
	[System.String] Key of the label to be updated. Required for both dynamic and static labels.

.PARAMETER LabelValue
	[System.String] Value of the label to be updated. Required for both dynamic and static labels.

.INPUTS
	None. This function takes no pipeline input.

.OUTPUTS
	

#>
Function Set-GCLabel {

	[cmdletbinding()]
	Param (
		[Parameter(Mandatory=$false)][Switch]$Dynamic,
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false)][System.Array]$Assets,
		[Parameter(Mandatory=$false)][System.String]$LabelId,
		[Parameter(Mandatory=$true)][System.String]$LabelKey,
		[Parameter(Mandatory=$true)][System.String]$LabelValue
	)
	Begin {
		$Headers = Set-GCHeaders -Token $Key.Token
		
		If ($Dynamic) {
			$Method = "PUT"
			$Uri = $Key.Uri + "visibility/labels/" + $LabelId
			$Body = ''
		} else {
			$Method = "POST"
			$Uri = $Key.Uri + "assets/labels/" + $LabelKey + "/" + $LabelValue
			$Body = '{"vms": ['
		}
		
	}
	Process {
		If ($Dynamic) {
			
		} else {
			foreach ($Asset in $Assets) {
				$Body += '"' + $Asset.Id + '",'
			}
			
			$Body = $Body.SubString(0,$Body.Length-1)
			$Body += ']}'
			
			$Return = Invoke-WebRequest -UseBasicParsing -Uri $Uri -Headers $Headers -Body $Body -Method "POST"
		}
	}
	End {
		$Return
	}
}