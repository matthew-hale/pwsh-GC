function Get-Label {
    [CmdletBinding()]
    param (
		[String]
		$Search,

        [System.String]
        $LabelKey,

        [System.String]
        $LabelValue,

        [Switch]
        $FindMatches,

        [Int32]
        $DynamicCriteriaLimit = 10,

        [ValidateRange(0,1000)]
        [Int32]
        $Limit = 20,

        [ValidateRange(0,500000)]
        [Int32]
        $Offset,

        [Switch]
        $Raw,

        [PSTypeName("GCApiKey")]
        $ApiKey
    )

    if ( GCApiKey-present $ApiKey ) {
        if ( $ApiKey ) {
            $Key = $ApiKey
        } else {
            $Key = $global:GCApiKey
        }
        $Uri = "/visibility/labels"
    }

    # Building the request body with given parameters

    $Body = @{
        find_matches = $FindMatches:isPresent
		text_search = $Search
        key = $LabelKey
        value = $LabelValue
        dynamic_criteria_limit = $DynamicCriteriaLimit
        limit = $Limit
        offset = $Offset
    }

    # Removing empty keys

    $RequestBody = Remove-EmptyKeys $Body

    # Making the call

    if ( $Raw ) {
        pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
    } else {
        pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCLabel"); $_}
    }
}

