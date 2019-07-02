function Remove-EmptyKeys {
	param (
		$Body
	)

	$KeyList = New-Object -TypeName System.Collections.Generic.List[string]

	foreach ($HashKey in $Body.Keys) {
		$KeyList.Add($HashKey)
	}

	foreach ($HashKey in $KeyList) {
		if ([string]::isNullOrEmpty($Body[$HashKey])) {
			$Body.Remove($HashKey)
		}
	}

	$Body
}
