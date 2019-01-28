<#
.SYNOPSIS
	Encapsulates the "POST /visibility/labels/bulk" API request.

.DESCRIPTION
	Creates one or more static labels, based on a CSV file as input. This uses a different API request than a simple loop of New-GCStaticLabel calls would.

.PARAMETER Path
	The path to the CSV file used as input.

.INPUT
	None. This function accepts no pipeline input.

.OUTPUT
	application/json data

#>
function New-GCBulkStaticLabel {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)][ValidateScript({
			if (-not ($_ | Test-Path)) {
				throw "File or folder does not exist."
			}
			if (-not ($_ | Test-Path -PathType Leaf)) {
				throw "Target must be a file. Folders are not allowed."
			}
			$true
		})][System.IO.FileInfo]$Path
	)
	$Key = $global:GCApiKey

	$Sheet = Import-CSV $Path | Sort

	#Pulling label keys from the spreadsheet
	#This lets us parse the column names with more room for error; any column with "name" in it is identified as the vm name, and everything without "name" is a label key (header)
	$Headers = $Sheet | Get-Member -MemberType NoteProperty | Select-Object -Property Name | Where {-Not ($_.Name -match "name")}
	$Headers = $Headers.Name
	$Name = $Sheet | Get-Member -MemberType NoteProperty | Select-Object -Property Name | Where {$_.Name -match "name"}
	$Name = $Name.Name #This ends up being the column name of the column containing the vms, if that column had the word "name" in it

	#Getting assets from what's in the spreadsheet
	$AssetsFiltered = foreach ($Asset in $Sheet) {
		Get-GCAsset -Search $Asset.$Name -Limit 1
	}

	#Building our label objects from the data we've gathered
	#We iterate through each combination of Key: Value and create a Label object containing the asset_ids that match that Key:Value pair
	$Labels = foreach ($Header in $Headers) {
		$Values = foreach ($Line in $Sheet) {
			$Line.$Header
		}
		$Values = $Values | Sort -Unique
		foreach ($Value in $Values) {
			$Label = [PSCustomObject]@{
				"key" = $Header
				"value" = $Value
				"asset_ids" = @($AssetsFiltered | where {($Sheet | where {$_.$Header -eq $Value} | Select-Object -ExpandProperty Name) -contains $_.vm_name} | Select-Object -ExpandProperty id)
			}
			$Label
		}
	}

	#Now we can make the API call
	$Labels | New-GCBulkStaticLabelPrivate
}