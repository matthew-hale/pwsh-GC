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
function ConvertFrom-GCUnixTime {

	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][Int64]$UnixDate
	)
	process {
		$Origin = New-Object DateTime 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc)
		$Converted = $Origin.AddSeconds([Int]($UnixDate/1000)) #Remember: GuardiCore works with epoch times in milliseconds
	}
	end {
		$Converted.ToLocalTime()
	}
}
