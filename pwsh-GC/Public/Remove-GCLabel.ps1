function Remove-GCLabel {
    
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [PSTypeName("GCLabel")]
        $Label,

        [PSTypeName("GCApiKey")]
        $ApiKey
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
        foreach ($ThisLabel in $Label) {
            $Uri = "/visibility/labels/" + $ThisLabel.id
            pwsh-GC-delete-request -Uri $Uri -ApiKey $Key
        }
    }
}

