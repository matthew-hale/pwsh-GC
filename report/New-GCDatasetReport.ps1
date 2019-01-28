param (
	[Parameter(mandatory=$false)][String]$Key,
	[Parameter(mandatory=$false)][String]$Value,
	[Parameter(mandatory=$false)][Object[]]$Pairs,
	[Parameter(Mandatory=$true)][ValidateScript({
		if (-not ($_ | Test-Path)) {
			throw "Path does not exist."
		}
		if (-not ($_ | Test-Path -PathType Container)) {
			throw "Target must be a directory. Direct file paths not allowed."
		}
		$true
	})][System.IO.FileInfo]$DatasetPath	
)

if ($Pairs) {
	$ClientProcessTable = ./Query-GCClientProcess.ps1 -Pairs $Pairs -DatasetPath $DatasetPath | ConvertTo-Html -Fragment
} else {
	$ClientProcessTable = ./Query-GCClientProcess.ps1 -Key $Key -Value $Value -DatasetPath $DatasetPath | ConvertTo-Html -Fragment
}

if ($Pairs) {
	$ListeningProcessTable = ./Query-GCListeningProcess.ps1 -Pairs $Pairs -DatasetPath $DatasetPath | ConvertTo-Html -Fragment
} else {
	$ListeningProcessTable = ./Query-GCListeningProcess.ps1 -Key $Key -Value $Value -DatasetPath $DatasetPath | ConvertTo-Html -Fragment
}

if ($Pairs) {
	$ListeningSourceTable = ./Query-GCListeningSource.ps1 -Pairs $Pairs -DatasetPath $DatasetPath | ConvertTo-Html -Fragment
} else {
	$ListeningSourceTable = ./Query-GCListeningSource.ps1 -Key $Key -Value $Value -DatasetPath $DatasetPath | ConvertTo-Html -Fragment
}

$Style = 
@'

td, th {
	text-align: left;
	padding-right: 20px;
}

'@

$XmlPath = "$PSScriptRoot/index.html"
"" > $XmlPath
$XmlPath = Get-ChildItem $XmlPath | Select-Object -ExpandProperty FullName

$Writer = New-Object System.Xml.XmlTextWriter($XmlPath,$null)
$Writer.Formatting = "Indented"
$Writer.Indentation = "1"
$Writer.IndentChar = "`t"
$Writer.WriteStartDocument()
$Writer.WriteStartElement("html")
	$Writer.WriteStartElement("head")
		$Writer.WriteStartElement("title")
			$Writer.WriteRaw("Report")
		$Writer.WriteEndElement()
		$Writer.WriteStartElement("style")
			$Writer.WriteRaw($Style)
		$Writer.WriteEndElement()
	$Writer.WriteEndElement()
	$Writer.WriteStartElement("body")
		$Writer.WriteStartElement("h2")
			$Writer.WriteRaw("Client Processes")
		$Writer.WriteEndElement()
		$Writer.WriteRaw($ClientProcessTable)
		$Writer.WriteStartElement("h2")
			$Writer.WriteRaw("Server Processes")
		$Writer.WriteEndElement()
		$Writer.WriteRaw($ListeningProcessTable)
		$Writer.WriteStartElement("h2")
			$Writer.WriteRaw("Server Sources")
		$Writer.WriteEndElement()
		$Writer.WriteRaw($ListeningSourceTable)
	$Writer.WriteEndElement()
$Writer.WriteEndElement()
$Writer.WriteEndDocument()
$Writer.Flush()
$Writer.Close()
