<#
.SYNOPSIS
	Encapsulates the "GET /visibility/policy/sections/{section_name}/rules" API call

.DESCRIPTION
	Returns one or more policy objects based on given parameters.

.PARAMETER Search
	Generic search string; searches comments, rulesets, sources & destinations.

.PARAMETER Protocol
	Accepts TCP and/or UDP.
	
.PARAMETER Action
	The section that the policy resides; accepts allow, alert, block, override.
	
.PARAMETER Port
	One or more ports that are included in the policy.
	
.PARAMETER SourceLabel

.PARAMETER DestinationLabel

.PARAMETER AnySideLabel

.PARAMETER SourceProcess

.PARAMETER DestinationProcess

.PARAMETER AnySideProcess

.PARAMETER SourceAsset

.PARAMETER DestinationAsset

.PARAMETER AnySideAsset

.PARAMETER SourceSubnet

.PARAMETER DestinationSubnet

.PARAMETER AnySideSubnet

.PARAMETER Ruleset

.PARAMETER Comments

.PARAMETER SourceInternet

.PARAMETER DestinationInternet

.PARAMETER AnySideInternet

.PARAMETER Limit

.PARAMETER Offset

.INPUTS
	

.OUTPUTS
	

#>
function Get-GCPolicy {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][System.String]$Search,
		[Parameter(Mandatory=$false)][ValidateSet("TCP","UDP")][System.Array]$Protocol = @("TCP","UDP"),
		[Parameter(Mandatory=$false)][ValidateSet("allow","alert","block","override")][System.String]$Action = "allow",
		[Parameter(Mandatory=$false)][ValidateRange(1,65535)][System.Array]$Port,
		[Parameter(Mandatory=$false)][PSTypeName("GCLabel")]$SourceLabel,
		[Parameter(Mandatory=$false)][PSTypeName("GCLabel")]$DestinationLabel,
		[Parameter(Mandatory=$false)][PSTypeName("GCLabel")]$AnySideLabel,
		[Parameter(Mandatory=$false)][System.Array]$SourceProcess,
		[Parameter(Mandatory=$false)][System.Array]$DestinationProcesse
		[Parameter(Mandatory=$false)][System.Array]$AnySideProcess,
		[Parameter(Mandatory=$false)][PSTypeName("GCAsset")]$SourceAsset,
		[Parameter(Mandatory=$false)][PSTypeName("GCAsset")]$DestinationAsset,
		[Parameter(Mandatory=$false)][PSTypeName("GCAsset")]$AnySideAsset,
		[Parameter(Mandatory=$false)][System.String]$SourceSubnet,
		[Parameter(Mandatory=$false)][System.String]$DestinationSubnet,
		[Parameter(Mandatory=$false)][System.String]$AnySideSubnet,
		[Parameter(Mandatory=$false)][System.String]$Ruleset,
		[Parameter(Mandatory=$false)][System.String]$Comments,
		[Parameter(Mandatory=$false)][Switch]$SourceInternet,
		[Parameter(Mandatory=$false)][Switch]$DestinationInternet,
		[Parameter(Mandatory=$false)][Switch]$AnySideInternet,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Limit,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Offset
	)
	
	$Key = $Global:GCApiKey
	
	$Uri = $Key.Uri + "visibility/policy/sections/" + $Action + "/rules?"
	
	#Protocols has a default value, so we can just add it without checks
	$Uri += "protocols="
	foreach ($P in $Protocol) {
		$Uri += $P + ","
	}
	$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
	
	if ($Limit) {
		$Uri += "&limit=" + $Limit
	}
	
	if ($Offset) {
		$Uri += "&offset=" + $Offset
	}
	
	if ($Search) {
		$Uri += "&search=" + $Search
	}
	
	##### SOURCES #####
	
	$Uri += "&source="
	
	if ($SourceLabel) {
		$Uri += "labels:"
		foreach ($Group in $SourceLabel) {
			foreach ($Label in $Group) {
				$Uri += $Label.id + ">"
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ">"
			
			$Uri += "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($SourceProcess) {
		$Uri += "processes:"
		foreach ($Process in $SourceProcesses) {
			$Uri += $Process + "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($SourceAsset) {
		$Uri += "assets:"
		foreach ($Asset in $SourceAsset) {
			$Uri += $Asset.id + "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($SourceSubnet) {
		$Uri += "subnet:" + $SourceSubnet + ","
	}
	
	if ($PSBoundParameters.ContainsKey("SourceInternet")) { #checks for the existence of the parameter
		if ($SourceInternet -eq $true) {
			$Uri += "address_classification:Internet,"
		} elseif ($SourceInternet -eq $false) {
			$Uri += "address_classification:Private,"
		}
	}
	
	#If any above parameter was present, remove the trailing ","; if nothing above was present, remove "source="
	if ($Uri.SubString($Uri.length-1) -eq ",") {
		$Uri = $Uri.SubString(0,$Uri.length-1)
	} else {
		$Uri = $Uri.SubString(0,$Uri.length-8)
	}
	
	###################
	
	##### DESTINATIONS #####
	
	$Uri += "&destination="
	
	if ($DestinationLabel) {
		$Uri += "labels:"
		foreach ($Group in $DestinationLabel) {
			foreach ($Label in $Group) {
				$Uri += $Label.id + ">"
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ">"
			
			$Uri += "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($DestinationProcesses) {
		$Uri += "processes:"
		foreach ($Process in $DestinationProcesses) {
			$Uri += $Process + "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($DestinationAssetIDs) {
		$Uri += "assets:"
		foreach ($Asset in $DestinationAssetIDs) {
			$Uri += $Asset + "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($DestinationSubnet) {
		$Uri += "subnet:" + $DestinationSubnet + ","
	}
	
	if ($PSBoundParameters.ContainsKey("DestinationInternet")) {
		if ($DestinationInternet -eq $true) {
			$Uri += "address_classification:Internet,"
		} elseif ($DestinationInternet -eq $false) {
			$Uri += "address_classification:Private,"
		}
	}
	
	#If any above parameter was present, remove the trailing ","; if nothing above was present, remove "&destination="
	if ($Uri.SubString($Uri.length-1) -eq ",") {
		$Uri = $Uri.SubString(0,$Uri.length-1)
	} else {
		$Uri = $Uri.SubString(0,$Uri.length-13)
	}
	
	########################
	
	##### ANY SIDE #####
	
	$Uri += "&any_side="
	
	if ($AnySideLabelIDs) {
		$Uri += "labels:"
		foreach ($Group in $AnySideLabelIDs) {
			foreach ($ID in $Group) {
				$Uri += $ID + ">"
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ">"
			
			$Uri += "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($AnySideProcesses) {
		$Uri += "processes:"
		foreach ($Process in $AnySideProcesses) {
			$Uri += $Process + "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($AnySideAssetIDs) {
		$Uri += "assets:"
		foreach ($Asset in $AnySideAssetIDs) {
			$Uri += $Asset + "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($AnySideSubnet) {
		$Uri += "subnet:" + $AnySideSubnet + ","
	}
	
	if ($PSBoundParameters.ContainsKey("AnySideInternet")) { #checks for the existence of the parameter
		if ($AnySideInternet -eq $true) {
			$Uri += "address_classification:Internet,"
		} elseif ($AnySideInternet -eq $false) {
			$Uri += "address_classification:Private,"
		}
	}
	
	#If any above parameter was present, remove the trailing ","; if nothing above was present, remove "&any_side="
	if ($Uri.SubString($Uri.length-1) -eq ",") {
		$Uri = $Uri.SubString(0,$Uri.length-1)
	} else {
		$Uri = $Uri.SubString(0,$Uri.length-10)
	}
	
	####################
	
	if ($Comments) {
		$Uri += "&comments=" + $Comments
	}
	
	if ($Ruleset) {
		$Uri += "&ruleset=" + $Ruleset
	}
	
	if ($Port) {
		$Uri += "&port="
		foreach ($P in $Port) {
			$Uri += $P + ","
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
	}
	
	if ($Search) {
		$Uri += "&search=" + $Search
	}
	
	if ($State) {
		$Uri += "&state=" + $State
	}
	
	if ($Limit) {
		$Uri += "&limit=" + $Limit
	}
	
	if ($Offset) {
		$Uri += "&offset=" + $Offset
	}
	
	try {
		$Result = $(Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects") | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCPolicy"); $_}
	}
	catch {
		throw $_.Exception
	}
	
	$Result
}
