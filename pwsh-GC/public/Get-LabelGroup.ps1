function Get-LabelGroup {
    param (
        [String]
        $Key,

        [String]
        $Value,

        [PSTypeName("GCAsset")]
        $Asset,

        [PSTypeName("GCLabel")]
        $Label,

        [string[]]
        $Status,

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
            $RequestKey = $ApiKey
        } else {
            $RequestKey = $global:GCApiKey
        }
        $Uri = "/visibility/label-groups"
    }

    # Building the request body based on given parameters
    $Body = @{
        key = $Key
        value = $Value
        assets = $Asset.id -join ","
        criteria = $Label.id -join ","
        assets_status = $Status -join ","
        limit = $limit
        offset = $offset
    }

    # Removing empty hashtable keys
    $RequestBody = Remove-EmptyKeys $Body

    # Making the call
    if ( $Raw ) {
        pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $RequestKey
    } else {
        pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $RequestKey | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCLabelGroup"); $_}
    }
}

