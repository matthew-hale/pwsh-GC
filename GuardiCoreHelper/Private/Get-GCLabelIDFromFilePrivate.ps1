function Get-GCLabelIDFromFilePrivate {
	param (
		$Files
	)
	
	$LabelIDs = @()
	
	foreach ($File in $Files) {
		$LabelIDGroup = Import-CSV -Header IP $File | select -ExpandProperty IP
		$LabelIDs += @(,$LabelIDGroup)
	}
	
	$LabelIDs
}
