
<#
.SYNOPSIS
	Encapsulates the "GET /visibility/saved-maps" api request

.DESCRIPTION

.PARAMETER Search
	A generic search string; use this to search for maps by name.

.PARAMETER AuthorID
	ID of the map author.

.PARAMETER State
	Current state of the map; accepts "READY","IN_PROGRESS","QUEUED","CANCELLED","FAILED","EMPTY"

.PARAMETER Features
	Map features; accepts "include_processes","time_resolution"

.PARAMETER Asset
	One or more GCAsset objects.

.PARAMETER Label
	One or more GCLabel objects.

.PARAMETER TimeRange
	Array containing a start and end time, as DateTime objects.

.PARAMETER Limit
	The maximum number of results to return.

.PARAMETER Offset
	The index of the first result to return.

.INPUTS
	None. This function accepts no pipeline inputs.

.OUTPUTS
	PSTypeName="GCSavedMap"

#>
function Get-GCSavedMap {
	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][System.String]$Search,
		[Parameter(Mandatory=$false)][ValidateSet("READY","IN_PROGRESS","QUEUED","CANCELLED","FAILED","EMPTY")][System.String]$State,
		[Parameter(Mandatory=$false)][ValidateSet("include_processes","time_resolution")]$Features,
		[Parameter(Mandatory=$false)][PSTypeName("GCAsset")]$Asset,
		[Parameter(Mandatory=$false)][PSTypeName("GCLabel")]$Label,
		[Parameter(Mandatory=$false)][DateTime[]]$TimeRange,
		[Parameter(Mandatory=$false)][System.String]$AuthorID,
		[Parameter(Mandatory=$false)][Int32]$Limit,
		[Parameter(Mandatory=$false)][Int32]$Offset
	)
	begin {
		$Key = $Global:GCApiKey
		$Uri = $Key.Uri + "visibility/saved-maps?sort=id"
		
		if ($AuthorID) {
			$Uri += "&author_id="
			foreach ($ID in $AuthorID) {
				$Uri += $ID + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}
		
		if ($State) {
			$Uri += "&state="
			foreach ($S in $State) {
				$Uri += $S + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}
		
		if ($Features) {
			$Uri += "&features="
			foreach ($Feature in $Features) {
				$Uri += $Feature + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}
		
		if ($Asset) {
			$Uri += "&included_asset_ids="
			foreach ($A in $Asset) {
				$Uri += $A.id + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}
		
		if ($Label) {
			$Uri += "&included_label_ids="
			foreach ($L in $Label) {
				$Uri += $L.id + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.Length-1) #Remove trailing ","
		}
		
		if ($TimeRange) {
			if ($TimeRange.count -ne 2) {
				throw "Incorrect time range syntax"
			}
			
			$Range0 = $TimeRange[0] | ConvertTo-GCUnixTime
			$Range1 = $TimeRange[1] | ConvertTo-GCUnixTime
			
			$Uri += "&time_range_filter=" + $Range0 + "," + $Range1
		}
		
		if ($Search) {
			$Uri += "&search=" + $Search
		}
		
		if ($Limit) {
			$Uri += "&limit=" + $Limit
		}
		
		if ($Offset) {
			$Uri += "&offset=" + $Offset
		}
	}
	process {
		try {
			$Result = $(Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects") | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCSavedMap"); $_}
		}
		catch {
			throw $_.Exception
		}
	}
	end {
		$Result
	}
}
