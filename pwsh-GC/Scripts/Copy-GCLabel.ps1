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
	$DynamicCriteria = $Label.dynamic_criteria
	$AddedAssets = $Label.added_assets
    $Assets = foreach ($Asset in $AddedAssets) {
        Get-GCAsset -Search $Asset.name | Where-Object {$_.id -match $Asset._id}
    }
}
end {
	$NewLabel = Get-GCLabel -FindMatches -LabelKey $LabelKey -LabelValue $LabelValue
	if ($DynamicCriteria) {
        $NewLabel | Add-Member -MemberType NoteProperty -Name criteria -Value $DynamicCriteria
        $NewLabel.dynamic_criteria += $DynamicCriteria
	}

	$NewLabel | Set-GCLabel

	if ($AddedAssets) {
        New-GCStaticLabel -LabelKey $LabelKey -LabelValue $LabelValue -Asset $Assets
	}
}
