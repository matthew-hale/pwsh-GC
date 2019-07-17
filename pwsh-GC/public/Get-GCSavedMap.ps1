function Get-GCSavedMap {
    [CmdletBinding()]
    param (
        [System.String]
        $Search,

        [ValidateSet("READY","IN_PROGRESS","QUEUED","CANCELLED","FAILED","EMPTY")]
        [System.String]
        $State,

        [ValidateSet("include_processes","time_resolution")]
        $Features,

        [PSTypeName("GCAsset")]
        $Asset,

        [PSTypeName("GCLabel")]
        $Label,

        [DateTime[]]
        $TimeRange,

        [System.String]
        $AuthorID,

        [Int32]
        $Limit = 20,

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
        $Uri = "/visibility/saved-maps"
    }

    # Building request body from parameters

    $Body = @{
        author_id = $AuthorID -join ","
        state = $State -join ","
        features = $Features -join ","
        included_asset_ids = $Asset.id -join ","
        included_label_ids = $Label.id -join ","
        time_range_filter = ""
        search = $Search
        limit = $Limit
        offset = $Offset
    }

    # Weird parameter

    if ( $TimeRange ) {
        if ( $TimeRange.count -ne 2 ) {
            throw "Incorrect time range syntax"
        }

        $Range0 = $TimeRange[0] | ConvertTo-GCUnixTime
        $Range1 = $TimeRange[1] | ConvertTo-GCUnixTime

        $Body.time_range_filter = $Range0 + "," + $Range1
    }

    # Removing empty keys

    $RequestBody = Remove-EmptyKeys $Body

    if ( $Raw ) {
        pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
    } else {
        pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCSavedMap"); $_}
    }
}

