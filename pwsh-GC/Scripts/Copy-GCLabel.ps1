# Copies an existing label to a new label, specified by a new key/value

param (
	[Parameter(ValueFromPipeline=$true)][PSTypeName("GCLabel")]$Label,
	[Parameter(Mandatory=$true)][String]$LabelKey,
	[Parameter(Mandatory=$true)][String]$LabelValue
)
begin {
	New-GCBlankLabel -LabelKey $LabelKey -LabelValue $LabelValue
}
process {
	$Criteria = $Label.criteria | Select-Object -ExcludeProperty "label_id","source"
	$AddedAssets = $Label.added_assets
}
end {
	$NewLabel = Get-GCLabel -FindMatches -LabelKey $LabelKey -LabelValue $LabelValue
	if ($Criteria) {
		$NewLabel.criteria += $Criteria
	}
	if ($AddedAssets) {
		$NewLabel.added_assets = $AddedAssets
	}

	$NewLabel | Set-GCLabel
}
