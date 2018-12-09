param (
	[Parameter(mandatory=$false)][String]$Key,
	[Parameter(mandatory=$false)][String]$Value,
	[Parameter(mandatory=$false)][Object[]]$Pairs
)

if ($Pairs) {
	$SourceProcessTable = ./Query-GCSourceProcessPS.ps1 -Pairs $Pairs | ConvertTo-Html -Fragment
} else {
	$SourceProcessTable = ./Query-GCSourceProcessPS.ps1 -Key $Key -Value $Value | ConvertTo-Html -Fragment
}

if ($Pairs) {
	$DestinationProcessTable = ./Query-GCDestinationProcessPS.ps1 -Pairs $Pairs | ConvertTo-Html -Fragment
} else {
	$DestinationProcessTable = ./Query-GCDestinationProcessPS.ps1 -Key $Key -Value $Value | ConvertTo-Html -Fragment
}

$XmlPath = "./index.html"
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
	$Writer.WriteEndElement()
	$Writer.WriteStartElement("h2")
		$Writer.WriteRaw("Source Processes")
	$Writer.WriteEndElement()
	$Writer.WriteRaw($SourceProcessTable)
	$Writer.WriteStartElement("h2")
		$Writer.WriteRaw("Destination Processes")
	$Writer.WriteEndElement()
	$Writer.WriteRaw($DestinationProcessTable)
$Writer.WriteEndElement()
$Writer.WriteEndDocument()
$Writer.Flush()
$Writer.Close()