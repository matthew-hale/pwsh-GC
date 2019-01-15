<#
.SYNOPSIS
	Encapsulates the "POST /visibility/policy/sections/{section_name}/rules" API call

.DESCRIPTION
	Creates a new segmentation policy according to the given parameters.

.PARAMETER Action
	Policy section; accepts "allow","alert","block","override"

.PARAMETER Protocol 
	TCP and/or UDP protocols.

.PARAMETER Port
	One or more ports.

.PARAMETER PortRange

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

#>
function New-GCPolicy {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)][ValidateSet("allow","alert","block","override")][System.String]$Action,
		[Parameter(Mandatory=$false)][ValidateSet("TCP","UDP")][System.Array]$Protocol = @("TCP","UDP"),
		[Parameter(Mandatory=$false)][ValidateRange(1,65535)][System.Array]$Port,
		[Parameter(Mandatory=$false)][System.Array]$PortRange,
		[Parameter(Mandatory=$false)][System.Array]$SourceLabel,
		[Parameter(Mandatory=$false)][System.Array]$DestinationLabel,
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
		[Parameter(Mandatory=$false)][System.Array]$SourceProcesses,
		[Parameter(Mandatory=$false)][System.Array]$DestinationProcesses,
		[Parameter(Mandatory=$false)][System.Array]$SourceAsset,
		[Parameter(Mandatory=$false)][System.Array]$DestinationAsset,
		[Parameter(Mandatory=$false)][System.String]$SourceSubnet,
		[Parameter(Mandatory=$false)][System.String]$DestinationSubnet,
		[Parameter(Mandatory=$false)][System.String]$Ruleset,
		[Parameter(Mandatory=$false)][System.String]$Comments,
		[Parameter(Mandatory=$false)][Switch]$SourceInternet,
		[Parameter(Mandatory=$false)][Switch]$DestinationInternet
	)
	$Key = $global:GCApiKey
	
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
			ip_protocols = $Protocol
			action = $Action
		}
	}
	
	if ($Port) {
		$Body.rule.ports = $Port
	}
	
	if ($PortRange) {
		#The validation doesn't work in ValidateScript for some reason, so I'm just doing it here
		foreach ($P in $PortRange) {
			if ($P.length -ne 2) {
				throw "Parameter PortRange: Each range must consist of starting and ending port"
			}
			
			foreach ($Port in $P) {
				if (-not (($Port -is [int]) -and ($Port -gt 0) -and ($Port -lt 65536))) {
					throw "Parameter PortRange: Ports may only be integers from 1 to 65535"
				}
			}
			
			if ($P[1] -le $P[0]) {
				throw "Parameter PortRange: Each range's end value must be greater than its start value"
			}
			
			$port_range = [PSCustomObject]@{
				start = $P[0]
				end = $P[1]
			}
			
			$Body.rule.port_ranges += $port_range
		}
	}
	
	if ($SourceLabel) {
		$temp = [PSCustomObject]@{}
		$Body.rule.source | Add-Member -MemberType NoteProperty -Name labels -Value $temp
		$Body.rule.source.labels | Add-Member -MemberType NoteProperty -Name or_labels -Value @()
		
		$or_labels = @()
		
		foreach ($Group in $SourceLabel) {
			$and_labels = [PSCustomObject]@{
				and_labels = @()
			}
		
			foreach ($Item in $Group) {
				$and_labels.and_labels += $Item.id
			}
			
			$or_labels += $and_labels
		}
		
		$Body.rule.source.labels.or_labels = $or_labels
	}
	
	if ($DestinationLabel) {
		$temp = [PSCustomObject]@{}
		$Body.rule.destination | Add-Member -MemberType NoteProperty -Name labels -Value $temp
		$Body.rule.destination.labels | Add-Member -MemberType NoteProperty -Name or_labels -Value @()
		
		$or_labels = @()
		
		foreach ($Group in $DestinationLabel) {
			$and_labels = [PSCustomObject]@{
				and_labels = @()
			}
		
			foreach ($Item in $Group) {
				$and_labels.and_labels += $Item.id
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
	
	if ($SourceAsset) {
		$Body.rule.source | Add-Member -MemberType NoteProperty -Name asset_ids -Value @($SourceAsset.id)
	}
	
	if ($DestinationAsset) {
		$Body.rule.destination | Add-Member -MemberType NoteProperty -Name asset_ids -Value @($DestinationAsset.id)
	}
	
	if ($SourceSubnet) {
		$Body.rule.source | Add-Member -MemberType NoteProperty -Name subnet -Value $SourceSubnet
	}
	
	if ($DestinationSubnet) {
		$Body.rule.destination | Add-Member -MemberType NoteProperty -Name subnet -Value $DestinationSubnet
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
	#$BodyJson
}
