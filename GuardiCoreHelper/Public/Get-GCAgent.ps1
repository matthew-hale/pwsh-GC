<#
.SYNOPSIS
	Encapsulates the "GET /agents" API call.

.DESCRIPTION
	Gets one or more agents based on the given parameters/filters.

.PARAMETER Version
	[System.String] Version of the agent
	
.PARAMETER Kernel
	[System.String] Version of the kernel
	
.PARAMETER OS
	[System.String] General type of OS. Allows: "Unknown","Windows","Linux"
	
.PARAMETER Label
	[PSTypeName("GCLabel")] One or more GCLabel objects, as returned from Get-GCLabel
	
.PARAMETER Status
	[System.String] Status of the agent. Allows: "Online","Offline"
	
.PARAMETER Flags
	[Int32] Status flags. Allows: (1..14)
	
.PARAMETER Enforcement
	[System.String] Status of the enforcement module. Allows: "Active","Not Deployed","Disabled"

.PARAMETER Deception
	[System.String] Status of the deception module. Allows: "Active","Not Deployed"
	
.PARAMETER Detection
	[System.String] Status of the detection module. Allows: "Active","Not Deployed"
	
.PARAMETER Reveal
	[System.String] Status of the reveal module. Allows: "Active","Not Deployed"
	
.PARAMETER Activity
	[System.String] Time period of when the agent was last active. Allows: "last_month","last_week","last_12_hours","last_24_hours","not_active"
	
.PARAMETER GCFilter
	[System.String] Filter of Agent ID/Agent Hostname/IP Address.
	
.PARAMETER Limit
	[Int32] Max number of returned agents.
	
.PARAMETER Offset
	[Int32] Index of where the query will start returning results.
	
.INPUTS
	None. This function takes no pipeline input.

.OUTPUTS
	[PSTypeName("GCAgent")] One or more GCAgent objects.

#>
function Get-GCAgent {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][System.String]$Version,
		[Parameter(Mandatory=$false)][System.String]$Kernel,
		[Parameter(Mandatory=$false)][ValidateSet("Unknown","Windows","Linux")][System.String]$OS,
		[Parameter(Mandatory=$false)][PSTypeName("GCLabel")]$Label,
		[Parameter(Mandatory=$false)][ValidateSet("Online","Offline")][System.String]$Status, # = display_status
		[Parameter(Mandatory=$false)][ValidateRange(1,14)][Int32]$Flag,
		[Parameter(Mandatory=$false)][ValidateSet("Active","Not Deployed","Disabled")][System.String]$Enforcement, # = module_status_enforcement
		[Parameter(Mandatory=$false)][ValidateSet("Active","Not Deployed")][System.String]$Deception, # = module_status_deception
		[Parameter(Mandatory=$false)][ValidateSet("Active","Not Deployed")][System.String]$Detection, # = module_status_detection
		[Parameter(Mandatory=$false)][ValidateSet("Active","Not Deployed")][System.String]$Reveal,  # = module_status_reveal
		[Parameter(Mandatory=$false)][ValidateSet("last_month","last_week","last_12_hours","last_24_hours","not_active")][System.String]$Activity,
		[Parameter(Mandatory=$false)][System.String]$GCFilter,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Limit,
		[Parameter(Mandatory=$false)][ValidateRange(0,500000)][Int32]$Offset
	)
	begin {
		$Key = $global:GCApiKey
		$Uri = $Key.Uri + "agents?sort=version"
		
		#Building the Uri with given parameters
		if ($Version) {
			$Uri += "&version="
			foreach ($V in $Version) {
				$Uri += $V + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($Kernel) {
			$Uri += "&kernel="
			foreach ($K in $Kernel) {
				$Uri += $K + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($OS) {
			$Uri += "&os="
			foreach ($O in $OS) {
				$Uri += $O + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($Labels) {
			$Uri += "&labels="
			foreach ($L in $Label) {
				$Uri += $L.id + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($Status) {
			$Uri += "&display_status="
			foreach ($S in $Status) {
				$Uri += $S + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($Flags) {
			$Uri += "&status_flags="
			foreach ($F in $Flag) {
				$Uri += $F + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($Enforcement) {
			$Uri += "&module_status_enforcement="
			foreach ($E in $Enforcement) {
				if ($E -eq "Disabled") {
					$E = "Enforcement disabled from management console"
				}
				$Uri += $E + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($Deception) {
			$Uri += "&module_status_deception="
			foreach ($D in $Deception) {
				$Uri += $D + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($Detection) {
			$Uri += "&module_status_detection="
			foreach ($D in $Detection) {
				$Uri += $D + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($Reveal) {
			$Uri += "&module_status_reveal="
			foreach ($R in $Reveal) {
				$Uri += $R + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($Activity) {
			$Uri += "&activity="
			foreach ($A in $Activity) {
				$Uri += $A + ","
			}
			
			$Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing ","
		}
		
		if ($GCFilter) {
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
		$Result = $(Invoke-RestMethod -Uri $Uri -Authentication Bearer -Token $Key.Token -Method "GET" | Select-Object -ExpandProperty "objects") | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCAgent"); $_}
	}
	end {
		$Result
	}
}
