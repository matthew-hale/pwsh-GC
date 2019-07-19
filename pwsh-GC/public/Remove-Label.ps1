function Remove-Label {
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
            $Should = $Uri
            if ( $PSCmdlet.ShouldProcess($Should, "pwsh-GC-delete-request -Uri $Uri -ApiKey $Key") ) {
                pwsh-GC-delete-request -Uri $Uri -ApiKey $Key
            }
        }
    }
}

