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
function Get-GCAgent {

	[cmdletbinding()]
	param (
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
	begin {
		$Uri = $Key.Uri + "agents?"
		
		#Building the Uri with given parameters
		if ($Version) {
			$Uri += "&version=" + $Version
		}
		
		if ($Kernel) {
			$Uri += "&kernel=" + $Kernel
		}
		
		if ($OS) {
			$Uri += "&os=" + $OS
		}
		
		if ($Labels) {
			$Uri += "&labels=" + $Labels
		}
		
		if ($Status) {
			$Uri += "&display_status="
			if ($Status -eq "Disabled") {
				$Uri += "Enforcement disabled from management console"
			} else {
				$Uri += $Status
			}
		}
		
		if ($Flags) {
			$Uri += "&status_flags=" + $Flags
		}
		
		if ($Enforcement) {
			$Uri += "&module_status_enforcement=" + $Enforcement
		}
		
		if ($Deception) {
			$Uri += "&module_status_deception=" + $Deception
		}
		
		if ($Detection) {
			$Uri += "&module_status_detection=" + $Detection
		}
		
		if ($Reveal) {
			$Uri += "&module_status_reveal=" + $Reveal
		}
		
		if ($Activity) {
			$Uri += "&activity=" + $Activity
		}
		
		if ($GcFilter) {
			$Uri += "&gc_filter=" + $GcFilter
		}
		
		if ($Limit) {
			$Uri += "&limit=" + $Limit
		}
		
		if ($Offset) {
			$Uri += "&offset=" + $Offset
		}
	}
	process {
		$Agents = Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects"
	}
	end {
		$Agents
	}
}
