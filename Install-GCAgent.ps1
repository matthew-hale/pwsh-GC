<#
.SYNOPSIS
	Installs the GuardiCore agent on a local machine.

.DESCRIPTION
	To install the GuardiCore agent, an endpoint must browse to the aggregator IP, download an install script, and run the script with a passphrase. This script automates this process.

.PARAMETER AggregatorIP
	[System.String] IP address of the aggregator; the only validation performed is to check if the destination is up.
	
.PARAMETER ManagementPassword
	[System.String] Agent installation password defined by the management server configuration.

.INPUTS
	None. This script takes no pipeline inputs.

.OUTPUTS
	System.String

#>



Param (
	[Parameter(Mandatory=$true)][System.String]$AggregatorIP,
	[Parameter(Mandatory=$true)][System.String]$ManagementPassword
)

$InstallScript = "install.bat" #Hardcoded variable
$Uri = "https://" + $AggregatorIP + "/" + $InstallScript #This is done this way because I need to use $InstallScript again

#Testing connectivity to aggregator before we continue
$Connectivity = Test-Connection $AggregatorIP -Quiet -Count 2

#If the aggregator isn't reachable from here, log it and skip everything else
If ($Connectivity -ne $true) {
	$LogEntry = New-Object PSObject
	$LogEntry | Add-Member -MemberType NoteProperty -Name "Message" -Value "Aggregator Unreachable"
} else {
	$InstallPath = "$env:temp\" + $InstallScript
	$InstallCommand = $InstallPath + " " + $ManagementPassword
	
	<#this sometimes breaks, so I'm disabling it for now
	$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
	[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
	#>
	
	#This effectively bypasses the cert error you encounter manually browsing to this address.
	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {{$true}}
	
	#PS 2.0 support
	$Client = New-Object System.Net.WebClient
	$Client.DownloadFile($Uri,$InstallPath)
	
	& cmd.exe /c $InstallCommand
	$LogEntry = New-Object PSObject
	$LogEntry | Add-Member -MemberType NoteProperty -Name "Message" -Value "Script run"
} #End if/else

$LogEntry