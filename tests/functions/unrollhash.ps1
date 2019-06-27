function unrollhash ($HashTable) {
	$Out = foreach ($Key in ($HashTable.Keys | Sort-Object)) {
		$HashTable[$Key]
	}
	
	$Out -join ","
}

