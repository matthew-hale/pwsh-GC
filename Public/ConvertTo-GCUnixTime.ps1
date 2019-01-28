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
function ConvertTo-GCUnixTime {

	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][DateTime]$DateTime
	)
	process {
		$Origin = New-Object DateTime 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc)
		[Int64]$Converted = ($DateTime.ToUniversalTime()-$Origin).TotalMilliseconds
	}
	end {
		$Converted
	}
}
