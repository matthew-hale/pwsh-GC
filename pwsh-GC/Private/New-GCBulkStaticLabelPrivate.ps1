function New-GCBulkStaticLabelPrivate {
    param (
        [Parameter(ValueFromPipeline)]
        [System.Object[]]$Label,

        [PSTypeName("GCApiKey")]$ApiKey
    )
    begin {
        if ( GCApiKey-present $ApiKey ) {
            if ( $ApiKey ) {
                $Key = $ApiKey
            } else {
                $Key = $global:GCApiKey
            } 
            $Uri = "/visibility/labels/bulk"
        }
    }
    process {
        $Body = [PSCustomObject]@{
            "action" = "add"
            "labels" = $Labels
        }

        pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
    }
}

