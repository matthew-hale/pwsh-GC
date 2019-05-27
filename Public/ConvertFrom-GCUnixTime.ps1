function ConvertFrom-GCUnixTime {

	[cmdletbinding()]
	param (
		[Parameter(Mandatory,ValueFromPipeline)]
		[Int64]$UnixDate
	)
	begin {
		$Converted = [System.Collections.Generic.List[object]]::new()
	}
	process {
		foreach ( $ThisUnixDate in $UnixDate ) {
			$Origin = New-Object DateTime 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc)
			# Remember: GuardiCore works with epoch times in milliseconds
			$Converted.Add($Origin.AddSeconds([Int]($ThisUnixDate/1000))) 
		}
	}
	end {
		$Converted.ToLocalTime()
	}
}
