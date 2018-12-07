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

### This script can take some time to complete. Check the debug messages. ###

Import-Module .\Centra.psm1

[String]$OutPath = [String]$OutPath

if (($OutPath[$OutPath.length-1] -eq "/") -or ($OutPath[$OutPath.length-1] -eq "\")) {
	$OutPath = $OutPath.SubString(0,$OutPath.length-1)
}

$FlowPath = $OutPath + "\Flows"
$DataPath = $OutPath + "\Data"

mkdir $FlowPath > $null
mkdir $DataPath > $null
mkdir "$DataPath\Assets" > $null
mkdir "$DataPath\Labels" > $null
mkdir "$DataPath\Flows" > $null

Write-Host -NoNewLine Getting assets...
$Assets = Get-GCAsset -Key $Key -Offset 0 -Limit 1000
Write-Host done

Write-Host -NoNewLine Generating asset dataset...
$AssetPath = "$DataPath\Assets\assets.xml"
"" > $AssetPath
$XmlPath = Get-ChildItem $AssetPath | Select-Object -ExpandProperty FullName
$XmlWriter = New-Object System.Xml.XmlTextWriter($XmlPath,$null)
$XmlWriter.Formatting = "Indented"
$XmlWriter.Indentation = "1"
$XmlWriter.IndentChar = "`t"
$XmlWriter.WriteStartDocument()
$XmlWriter.WriteStartElement("Assets")
	$Headers = $Assets | Get-Member -MemberType NoteProperty | select -ExpandProperty Name
	foreach ($Asset in $Assets) {
		$XmlWriter.WriteStartElement("Asset")
			foreach ($Header in $Headers) {
				$XmlWriter.WriteStartElement($Header)
					$XmlWriter.WriteRaw($Asset.$Header)
				$XmlWriter.WriteEndElement()
			}
		$XmlWriter.WriteEndElement()
	}
$XmlWriter.WriteEndElement()
$XmlWriter.WriteEndDocument()
$XmlWriter.Flush()
$XmlWriter.Close()
Write-Host done

Write-Host -NoNewLine Getting labels...
$Labels = Get-GCLabel -Key $Key -FindMatches -Offset 0 -Limit 500
Write-Host done

Write-Host -NoNewLine Generating label dataset...
$LabelPath = "$DataPath\Labels\labels.xml"
"" > $LabelPath
$XmlPath = Get-ChildItem $LabelPath | Select-Object -ExpandProperty FullName
$XmlWriter = New-Object System.Xml.XmlTextWriter($XmlPath,$null)
$XmlWriter.Formatting = "Indented"
$XmlWriter.Indentation = "1"
$XmlWriter.IndentChar = "`t"
$XmlWriter.WriteStartDocument()
$XmlWriter.WriteStartElement("Labels")
	$Headers = $Labels | Get-Member -MemberType NoteProperty | select -Property Name,Definition | where {-not ($_.Definition -match "Object")} | select -ExpandProperty Name
	$SpecialHeaders = $Labels | Get-Member -MemberType NoteProperty | select -Property Name,Definition | where {$_.Definition -match "Object"} | select -ExpandProperty Name
	foreach ($Label in $Labels) {
		$XmlWriter.WriteStartElement("Label")
			foreach ($Header in $Headers) {
				$XmlWriter.WriteStartElement($Header)
					$XmlWriter.WriteRaw($Label.$Header)
				$XmlWriter.WriteEndElement()
			}
			foreach ($SpecialHeader in $SpecialHeaders) {
				if ($Label.$SpecialHeader) {
					$NewHeaders = $Label.$SpecialHeader | Get-Member -MemberType NoteProperty | select -ExpandProperty Name
				}
				$XmlWriter.WriteStartElement($SpecialHeader)
				if ($NewHeaders) {
					foreach ($NewHeader in $NewHeaders) {
						$XmlWriter.WriteStartElement($NewHeader)
							$XmlWriter.WriteRaw($Label.$SpecialHeader.$NewHeader)
						$XmlWriter.WriteEndElement()
					}
				}
				$XmlWriter.WriteEndElement()
			}
		$XmlWriter.WriteEndElement()
	}
$XmlWriter.WriteEndElement()
$XmlWriter.WriteEndDocument()
$XmlWriter.Flush()
$XmlWriter.Close()
Write-Host done

Write-Host -NoNewLine Getting flows...
.\Get-GCFlowJob.ps1 -Key $Key -StartTime $StartTime -EndTime $EndTime -OutPath $FlowPath
Write-Host done

Write-Host -NoNewLine Generating flow dataset...
$FlowPathFiles = Get-ChildItem $FlowPath -Filter *.csv

foreach ($File in $FlowPathFiles) {
	$Flows = Import-CSV $File
	$Name = $File.Name
	$Path = "$DataPath\Flows\$Name"
	$Path = $Path.SubString(0,$Path.Length-3)
	$Path += "xml"
	"" > $Path
	
	$XmlPath = Get-ChildItem $Path | Select-Object -ExpandProperty FullName
	
	$XmlWriter = New-Object System.Xml.XmlTextWriter($XmlPath,$null)
	
	$XmlWriter.Formatting = "Indented"
	$XmlWriter.Indentation = "1"
	$XmlWriter.IndentChar = "`t"
	$XmlWriter.WriteStartDocument()
	$XmlWriter.WriteStartElement("Flows")
		foreach ($Flow in $Flows) {
			$Headers = $Flow | Get-Member -MemberType NoteProperty | select -ExpandProperty Name
			$XmlWriter.WriteStartElement("Flow")
				foreach ($Header in $Headers) {
					$XmlWriter.WriteStartElement($Header)
						$XmlWriter.WriteRaw($Flow.$Header)
					$XmlWriter.WriteEndElement()
				}
			$XmlWriter.WriteEndElement()
		}
	$XmlWriter.WriteEndElement()
	$XmlWriter.WriteEndDocument()
	$XmlWriter.Flush()
	$XmlWriter.Close()
}
Write-Host done

Write-Host Dataset generation complete. Use .\Query-GCDataset to query the data, or do it manually with XPath statements via Select-Xml.
