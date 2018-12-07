#This set of queries returns the source processes (a combination of the process name and its corresponding executable) of all flows where the source node was a member of the "Type: DC" label

#Querying flows:

$Dataset = Get-ChildItem ".\Data\Labels" -Filter *.xml
$LabelResult = foreach ($File in $DataSet) {
	#"Give me all the flow objects which contain a "destination_domain" node whose content reads "demo-wsus.idealdemo.local"
	#The XPath for the above is:
	#'//Flow[destination_domain.text()=demo-wsus.idealdemo.local]'
	
	#XPath query in quotes:
	$XPath = "//Label[key='Type' and value='DC']/matching_assets"
	[Xml]$Xml = Get-Content $File
	$Xml | Select-Xml -XPath $XPath | Select-Object -ExpandProperty Node 
	#This returns as an array of PS objects; to return as XML (for further queries, maybe), omit the Select-Object cmdlet
}
$LabelIDs = $LabelResult._id.split(" ")

$Dataset = Get-ChildItem ".\Data\Flows" -Filter *.xml
$FlowResult = foreach ($File in $DataSet) {
	#"Give me all the flow objects which contain a "destination_domain" node whose content reads "demo-wsus.idealdemo.local"
	#The XPath for the above is:
	#'//Flow[destination_domain.text()=demo-wsus.idealdemo.local]'
	
	#XPath query in quotes:
	$XPath = "//Flow[source_node_id=($LabelIDs)]"
	[Xml]$Xml = Get-Content $File
	$Xml | Select-Xml -XPath $XPath | Select-Object -ExpandProperty Node
	#This returns as an array of PS objects; to return as XML (for further queries, maybe), omit the Select-Object cmdlet
	$Out
}

$SourceProcesses = $FlowResult | select -Property source_process,source_process_name | foreach {$_.source_process + "\" + $_.source_process_name} | sort -Unique

$Result = foreach ($P in $SourceProcesses) {
	$Split = $P.split("\")
	[PSCustomObject]@{
		Name = $Split[0].trim()
		Executable = $Split[1].trim()
	}
}

$Result
