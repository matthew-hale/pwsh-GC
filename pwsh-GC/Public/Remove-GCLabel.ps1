function Remove-GCLabel {
    [CmdletBinding(SupportsShouldProcess)]

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
            if ( $PSCmdlet.ShouldProcess($ThisLabel, "pwsh-GC-delete-request -Uri $Uri -ApiKey $Key") ) {
                pwsh-GC-delete-request -Uri $Uri -ApiKey $Key
            }
        }
    }
}

