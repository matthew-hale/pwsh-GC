function Get-Aggregator {
    [cmdletbinding()]
    param (
        [string]
        $Search,

        [ValidateSet("UP","DOWN")]
        [string[]]
        $Status,

        [string[]]
        $Version,

        [int32]
        $Limit = 20,

        [int32]
        $Offset,

        [switch]
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
        $Uri = "/agent_aggregators"
    }

    # Building the request body with given parameters

    $Body = @{
        gc_filter = $Search
        display_status = $Status -join ","
        version = $Version -join ","
        limit = $Limit
        offset = $Offset
    }

    # Removing empty hashtable keys
    $RequestBody = Remove-EmptyKeys $Body

    # Making the call
    if ( $Raw ) {
        pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
    } else {
        pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCAggregator"); $_}
    }
}

