<#
.SYNOPSIS
	Runs Install-GCAgent.ps1 on a list of remote machines.

.DESCRIPTION
	To install the GuardiCore agent, an endpoint must browse to the aggregator IP, download an install script, and run the script with a passphrase. If PowerShell remoting is enabled, this script can be used to install the agent to a list of remote computers.

.PARAMETER AggregatorIP
	[System.String] IP address of the aggregator; the only validation performed is to check if the destination is up.
	
.PARAMETER ManagementPassword
	[System.String] Agent installation password defined by the management server configuration.

.PARAMETER Computers
	[System.String] Path to text file containing a list of computers.

.INPUTS
	None. This script takes no pipeline inputs.

.OUTPUTS
	System.Array

#>



Param (
	[Parameter(Mandatory=$true)][System.String]$AggregatorIP,
	[Parameter(Mandatory=$true)][System.String]$ManagementPassword,
	[Parameter(Mandatory=$true)][System.String]$Computers
)

$ComputerList = Get-Content -Path $Computers

#Empty log
$Log = @()

#Iterating through the list of computers
ForEach-Object ($Computer in $ComputerList) {
	$Entry = New-Object PSObject
	$Entry | Add-Member -MemberType NoteProperty -Name "Computer" -Value $Computer
	Try {
		$Output = Invoke-Command -ComputerName $Computer -FilePath ".\Install-GCAgent.ps1" -ArgumentList $AggregatorIP,$ManagementPassword
		$Entry | Add-Member -MemberType NoteProperty -Name "Result" -Value $Output
	} Finally {
		#$Computer >> unavailable-computers.txt
		$Entry | Add-Member -MemberType NoteProperty -Name "Result" -Value "Script did not run, computer unavailable"
	}
	$Log += $Entry
}

$Log