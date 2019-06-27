function Set-GCLabel {
    
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [PSTypeName("GCLabel")]
        $Label 
    )
    
    begin {
        if ( GCApiKey-present $ApiKey ) {
            if ( $ApiKey ) {
                $Key = $ApiKey
            } else {
                $Key = $global:GCApiKey
            } 
        }
    }

    process {
        foreach ( $ThisLabel in $Label ) {
            $Uri = "/visibility/labels/" + $ThisLabel.id
            $RequestBody = $ThisLabel | select -ExcludeProperty id,_id

            pwsh-GC-post-request -Raw -Uri $Uri -Body $RequestBody -Method Put -ApiKey $Key
        }
    }
}

