#POST /visibility/saved-maps

function New-GCSavedMap{
	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][System.String]$Name,
		[Switch]$Public,
		[Parameter(Mandatory=$false)][HashTable]$FilterHashTableInclude,
		[Parameter(Mandatory=$false)][HashTable]$FilterHashTableExclude,
		[Parameter(Mandatory=$false)][DateTime]$StartTime,
		[Parameter(Mandatory=$false)][DateTime]$EndTime,
		[Parameter(Mandatory=$false)][System.Array]$TimeRange,
		[Switch]$IncludeProcesses,
		[Switch]$TimeResolution,
		[Switch]$EmailOnProgress
	)
	begin {
		$Key = $Global:GCApiKey
		$Uri = $Key.Uri + "visibility/saved-maps"
		
		$Body = [PSCustomObject]@{
			name = ""
			map_type = 1
			filters = [PSCustomObject]@{}
			start_time_filter = $null
			end_time_filter = $null
			include_processes = $false
			time_resolution = $false
			email_on_progress = $false
		}
		
		if (-not $StartTime) {
			$Body.start_time_filter = $($(Get-Date).AddHours(-1) | ConvertTo-GCUnixTime)
		}
		
		if (-not $EndTime) {
			$Body.end_time_filter = $(Get-Date | ConvertTo-GCUnixTime)
		}
		
		if ($StartTime) {
			$Body.start_time_filter = $StartTime | ConvertTo-GCUnixTime
		}
		
		if ($EndTime) {
			$Body.end_time_filter = $EndTime | ConvertTo-GCUnixTime
		}
		
		if ($Name) {
			$Body.name = $Name
		}
		
		if ($Public) {
			$Body.map_type = 0
		}
		
		if ($FilterHashTableInclude) {
			$temp = [PSCustomObject]@{}
			$Body.filters | Add-Member -MemberType NoteProperty -Name include -Value $temp
			foreach ($Hash in $FilterHashTableInclude.Keys) {
				$Body.filters.include | Add-Member -MemberType NoteProperty -Name $Hash -Value @($FilterHashTableInclude[$Hash])
			}
		}
		
		if ($FilterHashTableExclude) {
			$temp = [PSCustomObject]@{}
			$Body.filters | Add-Member -MemberType NoteProperty -Name exclude -Value $temp
			foreach ($Hash in $FilterHashTableExclude.Keys) {
				$Body.filters.exclude | Add-Member -MemberType NoteProperty -Name $Hash -Value @($FilterHashTableExclude[$Hash])
			}
		}
		
		if ($TimeRange) {
			if ($TimeRange.count -ne 2) {
				throw "Incorrect time range syntax"
			}
			
			$Start = $TimeRange[0] | ConvertTo-GCUnixTime
			$End = $TimeRange[1] | ConvertTo-GCUnixTime
			
			$Body.start_time_filter = $Start
			$Body.end_time_filter = $End
		}
		
		if ($IncludeProcesses) {
			$Body.include_processes = $true
		}
		
		if ($TimeResolution) {
			$Body.time_resolution = $true
		}
		
		if ($EmailOnProgress) {
			$Body.email_on_progress = $true
		}
	}
	process {
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		$Result = Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
	}
	end {
		$Result
	}
}
