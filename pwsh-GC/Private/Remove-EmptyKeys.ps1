function Remove-EmptyKeys {
	param (
		$Body
	)

	$KeyList = [System.Collections.Generic.List[string]]::new()

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
