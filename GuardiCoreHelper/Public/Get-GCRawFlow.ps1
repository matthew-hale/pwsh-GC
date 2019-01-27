function Get-GCFlow {
	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)][DateTime]$StartTime,
		[Parameter(Mandatory=$true)][DateTime]$EndTime,
		[Parameter(Mandatory=$true)][ValidateScript({
			if (-not ($_ | Test-Path)) {
				throw "Path does not exist."
			}
			if (-not ($_ | Test-Path -PathType Container)) {
				throw "Target must be a directory. Direct file paths not allowed.."
			}
			$true
		})][System.IO.FileInfo]$OutPath
	)
	
	#Ensure the out path has no trailing slash
	if (($OutPath[$OutPath.length-1] -eq "/") -or ($OutPath[$OutPath.length-1] -eq "\")) {
		$OutPath = $OutPath.SubString(0,$OutPath.length-1)
	}
	
	$Start = ConvertTo-GCUnixTime -DateTime $StartTime
	$End = ConvertTo-GCUnixTime -DateTime $EndTime
	
	$1Hour = 3600000
	$Counter = 0
	
	for ($j = $Start; $j -lt $End+1; $j += $1Hour) { #Start time to end time
		$FromTime = $Start + ($1Hour * $Counter)
		$ToTime = $FromTime + $1Hour
		for ($i = 0;$i -lt 500000; $i += 10000) { #chunks of 10000 for timeouts, maximum of offset = 500000 because of hard limit
			$Flows = Get-GCFlowPrivate -Offset $i -Limit 10000 -FromTime $FromTime -ToTime $ToTime
			if ($Flows.count -lt 1) {
				break
			}
			$Uid = [String]$j + "-" + [String]$i
			$Flows | Export-CSV "$OutPath\flow_$Uid.csv"
		}
		$Counter++
	}
}
