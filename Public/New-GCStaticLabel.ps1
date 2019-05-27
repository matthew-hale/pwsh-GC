function New-GCStaticLabel {

	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline)]
		[PSTypeName("GCAsset")]$Asset,

		[Parameter(Mandatory)]
		[System.String]$LabelKey,

		[Parameter(Mandatory)]
		[System.String]$LabelValue,

		[PSTypeName("GCApiKey")]$ApiKey
	)
	begin {
		if ( GCApiKey-present $ApiKey ) {
			if ( $ApiKey ) {
				$Key = $ApiKey
			} else {
				$Key = $global:GCApiKey
			} 
			$Uri = "/assets/labels/" + $LabelKey + "/" + $LabelValue
		}
		
		$Body = [PSCustomObject]@{
			"vms" = @()
		}
	}
	process {
		if ($Asset) {
			$Body.vms += foreach ($ThisAsset in $Asset) {
				$ThisAsset.id
			}
		}
	}
	end {
		pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
	}
}
