$Dataset = Get-ChildItem "./Data/Labels" -Filter *.xml
$Result = foreach ($File in $Dataset) {
	#"Give me all the flow objects which contain a "destination_domain" node whose content reads "demo-wsus.idealdemo.local"
	#The XPath for the above is:
	#'//Flow[destination_domain.text()=demo-wsus.idealdemo.local]'
	
	#XPath query in quotes:
	$XPath = ""
	[Xml]$Xml = Get-Content $File
	$Xml | Select-Xml -XPath $XPath | Select-Object -ExpandProperty Node 
	#This returns as an array of PS objects; to return as XML (for further queries, maybe), omit the Select-Object cmdlet
}
$Result
