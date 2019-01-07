#Encapsulates the "GET /visibility/policy/sections/{section_name}/rules" API call

function Get-GCPolicy {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][System.String]$Search,
		[Parameter(Mandatory=$false)][ValidateSet("TCP","UDP")][System.Array]$Protocols = @("TCP","UDP"),
		[Parameter(Mandatory=$false)][ValidateSet("allow","alert","block","block_and_alert")][System.String]$Action = "allow",
		[Parameter(Mandatory=$false)][ValidateRange(1,65535)][System.Array]$Ports,
		[Parameter(Mandatory=$false)][System.Array]$SourceLabelIDs,
		[Parameter(Mandatory=$false)][System.Array]$DestinationLabelIDs,
		[Parameter(Mandatory=$false)][System.Array]$AnySideLabelIDs,
		[Parameter(Mandatory=$false)][ValidateScript({
			if (-not ($_ | Test-Path)) {
				throw "Path does not exist."
			}
			if (-not ($_ | Test-Path -PathType Leaf)) {
				throw "Target must be a file."
			}
			$true
		})][String[]]$SourceLabelFile,
		[Parameter(Mandatory=$false)][ValidateScript({
			if (-not ($_ | Test-Path)) {
				throw "Path does not exist."
			}
			if (-not ($_ | Test-Path -PathType Leaf)) {
				throw "Target must be a file."
			}
			$true
		})][String[]]$DestinationLabelFile,
		[Parameter(Mandatory=$false)][ValidateScript({
			if (-not ($_ | Test-Path)) {
				throw "Path does not exist."
			}
			if (-not ($_ | Test-Path -PathType Leaf)) {
				throw "Target must be a file."
			}
			$true
		})][String[]]$AnySideLabelFile,
		[Parameter(Mandatory=$false)][System.Array]$SourceProcesses,
		[Parameter(Mandatory=$false)][System.Array]$DestinationProcesses,
		[Parameter(Mandatory=$false)][System.Array]$AnySideProcesses,
		[Parameter(Mandatory=$false)][System.Array]$SourceAssetIDs,
		[Parameter(Mandatory=$false)][System.Array]$DestinationAssetIDs,
		[Parameter(Mandatory=$false)][System.Array]$AnySideAssetIDs,
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
	
	$Key = $global:GCApiKey
	
	if ($SourceLabelFile) {
		$SourceLabelIDs = Get-GCLabelIDFromFilePrivate -File $SourceLabelFile
	}
	
	if ($DestinationLabelFile) {
		$DestinationLabelIDs = Get-GCLabelIDFromFilePrivate -File $DestinationLabelFile
	}
	
	if ($AnySideLabelFile) {
		$AnySideLabelIDs = Get-GCLabelIDFromFilePrivate -File $AnySideLabelFile
	}
	
	$Uri = $Key.Uri + "visibility/policy/sections/" + $Action + "/rules?"
	
	#Protocols has a default value, so we can just add it without checks
	$Uri += "protocols="
	foreach ($Protocol in $Protocols) {
		$Uri += $Protocol + ","
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
	
	if ($SourceLabelIDs) {
		$Uri += "labels:"
		foreach ($Group in $SourceLabelIDs) {
			foreach ($ID in $Group) {
				$Uri += $ID + ">"
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ">"
			
			$Uri += "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($SourceProcesses) {
		$Uri += "processes:"
		foreach ($Process in $SourceProcesses) {
			$Uri += $Process + "|"
		}
		
		$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"
		
		$Uri += ","
	}
	
	if ($SourceAssetIDs) {
		$Uri += "assets:"
		foreach ($Asset in $SourceAssetIDs) {
			$Uri += $Asset + "|"
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
	
	if ($DestinationLabelIDs) {
		$Uri += "labels:"
		foreach ($Group in $DestinationLabelIDs) {
			foreach ($ID in $Group) {
				$Uri += "$ID" + ">"
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
	
	if ($Ports) {
		$Uri += "&port="
		foreach ($Port in $Ports) {
			$Uri += $Port + ","
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
	
	Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects"
}
