param (
	[Parameter(Mandatory=$true)][PSCustomObject]$Key,
	[Parameter(Mandatory=$true)][DateTime]$StartTime,
	[Parameter(Mandatory=$true)][DateTime]$EndTime,
	[Parameter(Mandatory=$true)][ValidateScript({
		if (-not ($_ | Test-Path)) {
			throw "Path does not exist."
		}
		if (-not ($_ | Test-Path -PathType Container)) {
			throw "Target must be a directory. Direct file paths not allowed."
		}
		$true
	})][System.IO.FileInfo]$OutPath
)

### This script can take a looooooong time to complete. Check the debug messages. ###

Import-Module .\Centra.psm1

$FlowPath = [String]$OutPath + "\Flows"
$DataPath = [String]$OutPath + "\Data"

mkdir $FlowPath > $null
mkdir $DataPath > $null

Write-Host -NoNewLine Getting assets...
$Assets = Get-GCAsset -Key $Key -Offset 0 -Limit 1000
Write-Host done

Write-Host -NoNewLine Getting labels...
$Labels = Get-GCLabel -Key $Key -Offset 0 -Limit 500
Write-Host done

Write-Host -NoNewLine Getting flows...
.\Get-GCFlowJob.ps1 -Key $Key -StartTime $StartTime -EndTime $EndTime -OutPath $FlowPath
$Flows = foreach ($CSV in Get-ChildItem -Path $FlowPath -Filter *.csv) {
	Import-CSV $CSV
}
Write-Host done

Write-Host -NoNewLine Stripping flows...
$StrippedFlows = $Flows | Select-Object -Property slot_start_time,source_node_type,source_node_id,source_ip,destination_node_type,destination_node_id,destination_ip,source_process,source_process_name,destination_process,destination_process_name,destination_port
Write-Host done

Write-Host -NoNewLine Adding label names to each flow...
$NewFlows = foreach ($Flow in $StrippedFlows) {
	$SourceAsset = $Assets | where {$_.id -eq $Flow.source_node_id}
	$LabelsSource = $SourceAsset.labels
	
	$DestinationAsset = $Assets | where {$_.id -eq $Flow.destination_node_id}
	$LabelsDestination = $DestinationAsset.labels
	
	$OutFlow = [PSCustomObject]@{
		"Start Time" = (ConvertFrom-GCUnixTime -UnixDate $Flow.slot_start_time)
		"Source Type" = $Flow.source_node_type
		"Source ID" = $Flow.source_node_id
		"Source IP Address" = $Flow.source_ip
		"Destination Type" = $Flow.destination_node_type
		"Destination ID" = $Flow.destination_node_id
		"Destination IP Address" = $Flow.destination_ip
		"Source Process Name" = $Flow.source_process
		"Source Process Executable" = $Flow.source_process_name
		"Destination Process Name" = $Flow.destination_process
		"Destination Process Executable" = $Flow.destination_process_name
		"Destination Port" = $Flow.destination_port
		"Source Label IDs" = $LabelsSource
		"Destination Label IDs" = $LabelsDestination
	}
	$OutFlow
}
Write-Host done

########## CONFIGURE THESE LABELS BEFORE RUNNING THE SCRIPT ##########

#Step 1: pick key/value pairs for labels and assign them to variables like below:
Write-Host -NoNewLine Grouping flows by label...
$DomainControllerLabel = $Labels | where {($_.key -eq "Type") -AND ($_.value -eq "DC")}
$ExchangeLabel = $Labels | where {($_.key -eq "Type") -AND ($_.value -eq "Exchange")}

$DomainControllerSourceFlows = $NewFlows | where {$_."Source Label IDs" -Contains $DomainControllerLabel.id}
$DomainControllerDestinationFlows = $NewFlows | where {$_."Destination Label IDs" -Contains $DomainControllerLabel.id}
$ExchangeSourceFlows = $NewFlows | where {$_."Source Label IDs" -Contains $ExchangeLabel.id}
$ExchangeDestinationFlows = $NewFlows | where {$_."Destination Label IDs" -Contains $ExchangeLabel.id}
Write-Host done

#Grouping into single object
$OutFlows = [PSCustomObject]@{
	"DC sources" = $DomainControllerSourceFlows
	"DC destinations" = $DomainControllerDestinationFlows
	"Exchange sources" = $ExchangeSourceFlows
	"Exchange destinations" = $ExchangeDestinationFlows
}

######################################################################

Write-Host -NoNewLine Parsing relevant information...
$Headers = $OutFlows | Get-Member -MemberType NoteProperty
$FlowInfo = foreach ($Header in $Headers) {
	$N = $Header.Name
	
	#Parse out source processes
	$SourceProcesses = foreach ($Flow in $OutFlows.$N) {
		$Pair = $Flow | Select-Object -Property "Source Process Name","Source Process Executable"
		$Process = $Pair.'Source Process Name' + "\" + $Pair.'Source Process Executable'
		$Process
	}
	$SourceProcesses = $SourceProcesses | sort -Unique
	$SourceProcessesParsed = foreach ($Process in $SourceProcesses) {
		$ProcessSplit = $Process.Split('\')
		$ProcessObject = [PSCustomObject]@{
			"Source Process Name" = $ProcessSplit[0]
			"Source Process Executable" = $ProcessSplit[1]
		}
		$ProcessObject
	}
	
	#Parse out destination processes
	$DestinationProcesses = foreach ($Flow in $OutFlows.$N) {
		$Group = $Flow | Select-Object -Property "Destination Process Name","Destination Process Executable","Destination Port"
		$Process = $Group.'Destination Process Name' + "\" + $Group.'Destination Process Executable' + "\" + $Group.'Destination Port'
		$Process
	}
	$DestinationProcesses = $DestinationProcesses | sort -Unique
	$DestinationProcessesParsed = foreach ($Process in $DestinationProcesses) {
		$ProcessSplit = $Process.Split('\')
		$ProcessObject = [PSCustomObject]@{
			"Destination Process Name" = $ProcessSplit[0]
			"Destination Process Executable" = $ProcessSplit[1]
			"Destination Port" = $ProcessSplit[2]
		}
		$ProcessObject
	}
	
	$Info = [PSCustomObject]@{
		"Title" = $N
		"Source IPs" = $OutFlows.$N.'Source IP Address' | Sort -Unique
		"Source Processes" = $SourceProcessesParsed
		"Destination IPs" = $OutFlows.$N.'Destination IP Address' | Sort -Unique
		"Destination Processes" = $DestinationProcessesParsed
	}
	
	$Info
}
Write-Host done

Write-Host -NoNewLine Exporting raw data...
foreach ($Header in $Headers) {
	$N = $Header.Name
	
	mkdir $DataPath\$N > $null
	
	$OutFlows.$N | Export-CSV "$DataPath\$N\StrippedFlows.csv"
	$FlowInfo.$N | Export-Clixml -Depth 99 -Path "$DataPath\$N\FlowInfo.xml"
}
Write-Host done

### Generating HTML report ###
Write-Host -NoNewLine Generating HTML report...

#Index.html page
$IndexPath = "$OutPath\index.html"
"" > $IndexPath
$IndexPath = Get-ChildItem $IndexPath | Select-Object -ExpandProperty FullName

$XmlIndex = New-Object System.Xml.XmlTextWriter($IndexPath,$null)

$XmlIndex.Formatting = "Indented"
$XmlIndex.Indentation = "1"
$XmlIndex.IndentChar = "`t"
$XmlIndex.WriteStartDocument()
	$XmlIndex.WriteComment("Index for generated flow info")
	$XmlIndex.WriteStartElement("body")
		foreach ($Header in $Headers) {
			$N = $Header.Name
			
			$XmlIndex.WriteStartElement("p")
				$XmlIndex.WriteStartElement("a")
					$XmlIndex.WriteAttributeString("href", ".\Data\$N\$N`.xml")
					$XmlIndex.WriteRaw($N)
				$XmlIndex.WriteEndElement()
			$XmlIndex.WriteEndElement()
		}
	$XmlIndex.WriteEndElement()
$XmlIndex.WriteEndDocument()
$XmlIndex.Flush()
$XmlIndex.Close()

#Xml data from $FlowInfo
foreach ($Object in $FlowInfo) {
	$N = $Object.Title
	
	$XmlPath = "$DataPath\$N\$N.xml"
	"" > $XmlPath
	$XmlPath = Get-ChildItem $XmlPath | Select-Object -ExpandProperty FullName
	$XmlWriter = New-Object System.Xml.XmlTextWriter($XmlPath,$null)
	
	$XmlWriter.Formatting = "Indented"
	$XmlWriter.Indentation = "1"
	$XmlWriter.IndentChar = "`t"
	$XmlWriter.WriteStartDocument()
		$XmlWriter.WriteComment($N)
		$XmlWriter.WriteStartElement("Info")
			$XmlWriter.WriteComment("Source IPs")
			$XmlWriter.WriteStartElement("SourceIPs")
				foreach ($IP in $Object.'Source IPs') {
					$XmlWriter.WriteStartElement("IP")
						$XmlWriter.WriteRaw($IP)
					$XmlWriter.WriteEndElement()
				}
			$XmlWriter.WriteEndElement()
			
			$XmlWriter.WriteComment("Source Processes")
			$XmlWriter.WriteStartElement("SourceProcesses")
				foreach ($Process in $Object.'Source Processes') {
					$XmlWriter.WriteStartElement("Process")
						$Name = $Process.'Source Process Name'
						$Executable = $Process.'Source Process Executable'
						
						$XmlWriter.WriteAttributeString("Name", $Name)
						$XmlWriter.WriteAttributeString("Executable", $Executable)
						
						$XmlWriter.WriteStartElement("Name")
							$XmlWriter.WriteRaw($Name)
						$XmlWriter.WriteEndElement()
						
						$XmlWriter.WriteStartElement("Executable")
							$XmlWriter.WriteRaw($Executable)
						$XmlWriter.WriteEndElement()
					$XmlWriter.WriteEndElement()
				}
			$XmlWriter.WriteEndElement()
			
			$XmlWriter.WriteComment("Destination IPs")
			$XmlWriter.WriteStartElement("DestinationIPs")
				foreach ($IP in $Object.'Destination IPs') {
					$XmlWriter.WriteStartElement("IP")
						$XmlWriter.WriteRaw($IP)
					$XmlWriter.WriteEndElement()
				}
			$XmlWriter.WriteEndElement()
			
			$XmlWriter.WriteComment("Destination Processes")
			$XmlWriter.WriteStartElement("DestinationProcesses")
				foreach ($Process in $Object.'Destination Processes') {
					$XmlWriter.WriteStartElement("Process")
						$Name = $Process.'Destination Process Name'
						$Executable = $Process.'Destination Process Executable'
						$Port = $Process.'Destination Port'
						
						$XmlWriter.WriteAttributeString("Name", $Name)
						$XmlWriter.WriteAttributeString("Executable", $Executable)
						$XmlWriter.WriteAttributeString("Port", $Port)
						
						$XmlWriter.WriteStartElement("Name")
							$XmlWriter.WriteRaw($Name)
						$XmlWriter.WriteEndElement()
						
						$XmlWriter.WriteStartElement("Executable")
							$XmlWriter.WriteRaw($Executable)
						$XmlWriter.WriteEndElement()
						
						$XmlWriter.WriteStartElement("Port")
							$XmlWriter.WriteRaw($Port)
						$XmlWriter.WriteEndElement()
					$XmlWriter.WriteEndElement()
				}
			$XmlWriter.WriteEndElement()
		$XmlWriter.WriteEndElement() #End of Info element
	$XmlWriter.WriteEndDocument()
	$XmlWriter.Flush()
	$XmlWriter.Close()
	
	#Stylesheet generation
	
}
Write-Host done

#Returning $FlowInfo to the pipeline for further immediate analysis
Write-Host FlowInfo returned in pipeline`, script complete
$FlowInfo
