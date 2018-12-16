#Encapsulates the "POST /visibility/policy/sections/{section_name}/rules" API call

function New-GCPolicy {

	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)][PSCustomObject]$Key,
		[Parameter(Mandatory=$false)][ValidateSet("TCP","UDP")][System.Array]$Protocols = @("TCP","UDP"),
		[Parameter(Mandatory=$true)][ValidateSet("allow","alert","block","block_and_alert")][System.String]$Action,
		[Parameter(Mandatory=$false)][ValidateRange(1,65535)][System.Array]$Ports,
		[Parameter(Mandatory=$false)][System.Array]$PortRanges,
		[Parameter(Mandatory=$false)][System.Array]$SourceLabelIDs,
		[Parameter(Mandatory=$false)][System.Array]$DestinationLabelIDs,
		[Parameter(Mandatory=$true)][ValidateScript({
			if (-not ($_ | Test-Path)) {
				throw "Path does not exist."
			}
			if (-not ($_ | Test-Path -PathType Leaf)) {
				throw "Target must be a file."
			}
			$true
		})][String[]]$SourceLabelFile,
		[Parameter(Mandatory=$true)][ValidateScript({
			if (-not ($_ | Test-Path)) {
				throw "Path does not exist."
			}
			if (-not ($_ | Test-Path -PathType Leaf)) {
				throw "Target must be a file."
			}
			$true
		})][String[]]$DestinationLabelFile,
		[Parameter(Mandatory=$false)][System.Array]$SourceProcesses,
		[Parameter(Mandatory=$false)][System.Array]$DestinationProcesses,
		[Parameter(Mandatory=$false)][System.Array]$SourceAssetIDs,
		[Parameter(Mandatory=$false)][System.Array]$DestinationAssetIDs,
		[Parameter(Mandatory=$false)][System.String]$Ruleset,
		[Parameter(Mandatory=$false)][System.String]$Comments,
		[Parameter(Mandatory=$false)][Switch]$SourceInternet,
		[Parameter(Mandatory=$false)][Switch]$DestinationInternet
	)
	
	if ($SourceLabelFile) {
		$SourceLabelIDs = Get-GCLabelIDFromFilePrivate -File $SourceLabelFile
	}
	
	if ($DestinationLabelFile) {
		$DestinationLabelIDs = Get-GCLabelIDFromFilePrivate -File $DestinationLabelFile
	}
	
	$Uri = $Key.Uri + "visibility/policy/sections/" + $Action + "/rules"
	
	$ordering_value = $null #Required to be $null by the API call
	$ruleset_id = $null #Required to be $null by the API call
	
	$Body = [PSCustomObject]@{
		ordering_value = $ordering_value
		rule = [PSCustomObject]@{
			ruleset_id = $ruleset_id
			port_ranges = @()
			ports = @()
			source = [PSCustomObject]@{}
			destination = [PSCustomObject]@{}
			ip_protocols = $Protocols
			action = $Action
		}
	}
	
	if ($Ports) {
		$Body.rule.ports = $Ports
	}
	
	if ($PortRanges) {
		#The validation doesn't work in ValidateScript for some reason, so I'm just doing it here
		foreach ($PortRange in $PortRanges) {
			if ($PortRange.length -ne 2) {
				throw "Parameter PortRanges: Each range must consist of starting and ending port"
			}
			
			foreach ($Port in $PortRange) {
				if (-not (($Port -is [int]) -and ($Port -gt 0) -and ($Port -lt 65536))) {
					throw "Parameter PortRanges: Ports may only be integers from 1 to 65535"
				}
			}
			
			if ($PortRange[1] -le $PortRange[0]) {
				throw "Parameter PortRanges: Each range's end value must be greater than its start value"
			}
			
			$port_range = [PSCustomObject]@{
				start = $PortRange[0]
				end = $PortRange[1]
			}
			
			$Body.rule.port_ranges += $port_range
		}
	}
	
	if ($SourceLabelIDs) {
		$temp = [PSCustomObject]@{}
		$Body.rule.source | Add-Member -MemberType NoteProperty -Name labels -Value $temp
		$Body.rule.source.labels | Add-Member -MemberType NoteProperty -Name or_labels -Value @()
		
		$or_labels = @()
		
		foreach ($Group in $SourceLabelIDs) {
			$and_labels = [PSCustomObject]@{
				and_labels = $Group
			}
			
			$or_labels += $and_labels
		}
		
		$Body.rule.source.labels.or_labels = $or_labels
	}
	
	if ($DestinationLabelIDs) {
		$temp = [PSCustomObject]@{}
		$Body.rule.destination | Add-Member -MemberType NoteProperty -Name labels -Value $temp
		$Body.rule.destination.labels | Add-Member -MemberType NoteProperty -Name or_labels -Value @()
		
		$or_labels = @()
		
		foreach ($Group in $DestinationLabelIDs) {
			$and_labels = [PSCustomObject]@{
				and_labels = $Group
			}
			
			$or_labels += $and_labels
		}
		
		$Body.rule.destination.labels.or_labels = $or_labels
	}
	
	if ($SourceProcesses) {
		$Body.rule.source | Add-Member -MemberType NoteProperty -Name processes -Value $SourceProcesses
	}
	
	if ($DestinationProcesses) {
		$Body.rule.destination | Add-Member -MemberType NoteProperty -Name processes -Value $DestinationProcesses
	}
	
	if ($SourceAssetIDs) {
		$Body.rule.source | Add-Member -MemberType NoteProperty -Name asset_ids -Value $SourceAssetIDs
	}
	
	if ($DestinationAssetIDs) {
		$Body.rule.destination | Add-Member -MemberType NoteProperty -Name asset_ids -Value $DestinationAssetIDs
	}
	
	if ($PSBoundParameters.ContainsKey("SourceInternet")) { #checks for the existence of the parameter
		if ($SourceInternet -eq $true) {
			$Body.rule.source | Add-Member -MemberType NoteProperty -Name address_classification -Value "Internet"
		} elseif ($SourceInternet -eq $false) {
			$Body.rule.source | Add-Member -MemberType NoteProperty -Name address_classification -Value "Private"
		}
	}
	
	if ($PSBoundParameters.ContainsKey("DestinationInternet")) {
		if ($DestinationInternet -eq $true) {
			$Body.rule.destination | Add-Member -MemberType NoteProperty -Name address_classification -Value "Internet"
		} elseif ($DestinationInternet -eq $false) {
			$Body.rule.destination | Add-Member -MemberType NoteProperty -Name address_classification -Value "Private"
		}
	}
	
	if ($Comments) {
		$Body.rule | Add-Member -MemberType NoteProperty -Name comments -Value $Comments
	}
	
	if ($Ruleset) {
		$Body.rule | Add-Member -MemberType NoteProperty -Name ruleset_name -Value $Ruleset
	}
	
	$BodyJson = $Body | ConvertTo-Json -Depth 99
	Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
}
