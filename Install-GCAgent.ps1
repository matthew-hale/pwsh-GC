<#
.SYNOPSIS
	Installs the GuardiCore agent onto a list of computers as defined in $Computers.

.DESCRIPTION
	To install the GuardiCore agent, an endpoint must browse to the aggregator IP, download an install script, and run the script with a passphrase. This script automates this process across a set of endpoints.

.PARAMETER AggregatorIP
	[System.String] IP address of the aggregator; the only validation performed is to check if the destination is up.
	
.PARAMETER ManagementPassword
	[System.String] Agent installation password defined by the management server configuration.
	
.PARAMETER Computers
	[System.String] Path to file containing the target computers.

.INPUTS
	None. This script takes no pipeline inputs.

.OUTPUTS
	System.String

#>



Param (
	[Parameter(Mandatory=$true)][System.String]$AggregatorIP,
	[Parameter(Mandatory=$true)][System.String]$ManagementPassword,
	[Parameter(Mandatory=$true)][System.String]$Computers
)

$InstallScript = "install.bat" #Hardcoded variable, I know, I know
$Uri = "https://" + $AggregatorIP + "/" + $InstallScript #This is done this way because I may need to use $InstallScript again

Return "Test"