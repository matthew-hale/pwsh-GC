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

$InstallScript = "install.bat" #Hardcoded variable, I know, I know
$Uri = "https://" + $AggregatorIP + "/" + $InstallScript #This is done this way because I may need to use $InstallScript again

$RemoteScript = {
#Testing connectivity to aggregator before we continue
$Connectivity = Test-Connection $AggregatorIP -Quiet -Count 2

#If the aggregator isn't reachable from here, log it and skip everything else
If ($Connectivity -ne $true) {
	$LogEntry = [PSCustomObject]@(
		Message = "Aggregator unreachable"
	)
} else {
	$InstallPath = $HOME + "\Downloads\" + $InstallScript
	$InstallCommand = $InstallPath + " " + $ManagementPassword

	#These are so that we can reset these values after we mess with them to get the cert working
	$DefaultSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
	$DefaultCertificatePolicy = [System.Net.ServicePointManager]::CertificatePolicy

	<#
	This effectively bypasses the cert error you encounter manually browsing to this address.
	First a new class is created called "TrustAllCertsPolicy," which contains a method called "CheckValidationResult."
	This method simply returns true.
	Then we enable all security protocols, and set our new class to be our CertificatePolicy.
	It's not really ideal but what can you do :P
	#>
	#Tabbing breaks this for some reason
Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
public bool CheckValidationResult(
ServicePoint srvPoint, X509Certificate certificate,
WebRequest request, int certificateProblem) {
return true;
}
}
"@

	$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
	[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
	[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

	Invoke-WebRequest -UseBasicParsing -Uri $Uri -Method "Get"
	cmd.exe /c $InstallCommand
	$LogEntry = [PSCustomObject]@(
		Message = "Script run"
	)
} #End if/else

$LogEntry