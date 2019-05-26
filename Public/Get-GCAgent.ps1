function Get-GCAgent {

	[CmdletBinding()]
	param (
		[String[]]$Version,

		[String[]]$Kernel,

		[ValidateSet("Unknown","Windows","Linux")][String[]]$OS,

		[PSTypeName("GCLabel")]$Label,

		[ValidateSet("Online","Offline")][String[]]$Status, # = display_status

		[ValidateSet("undefined",1,2,3,4,5,6,7,8,9,10,11,12,13,14)]$Flag,

		[ValidateSet("Active","Not Deployed","Disabled")][String[]]$Enforcement, # = module_status_enforcement

		[ValidateSet("Active","Not Deployed")][String[]]$Deception, # = module_status_deception

		[ValidateSet("Active","Not Deployed")][String[]]$Detection, # = module_status_detection

		[ValidateSet("Active","Not Deployed")][String[]]$Reveal,  # = module_status_reveal

		[ValidateSet("last_month","last_week","last_12_hours","last_24_hours","not_active")][String[]]$Activity,

		[String]$Search,

		[ValidateRange(0,1000)][Int32]$Limit = 20,

		[ValidateRange(0,500000)][Int32]$Offset,

		[Switch]$Raw,

		[PSTypeName("GCApiKey")]$ApiKey
	)

	if ( GCApiKey-present $ApiKey ) {
		if ( $ApiKey ) {
			$Key = $ApiKey
		} else {
			$Key = $global:GCApiKey
		} 
		$Uri = "/agents"
	}
	
	# Building the request body with given parameters
	
	$Body = @{
		version = $Version -join ","
		kernel = $Kernel -join ","
		os = $OS -join ","
		labels = $Label.id -join ","
		display_status = $Status -join ","
		status_flags = $Flag -join ","
		module_status_deception = $Deception -join ","
		module_status_detection = $Detection -join ","
		module_status_reveal = $Reveal -join ","
		activity = $Activity -join ","
		gc_filter = $Search
		limit = $Limit
		offset = $Offset
	}

	# This one's unique
	if ($Enforcement) {
		$Add += foreach ($ThisEnforcement in $Enforcement) {
			if ($ThisEnforcement -eq "Disabled") {
				$ThisEnforcement = "Enforcement disabled from management console"
				$ThisEnforcement
			} else {
				$ThisEnforcement
			}
		}

		$Body.module_status_enforcement = $Add -join ","
	}

	# Removing empty hashtable keys
	$RequestBody = Remove-EmptyKeys $Body

	# Making the call
	if ($Raw) {
		pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
	} else {
		pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCAgent"); $_}
	}
}

