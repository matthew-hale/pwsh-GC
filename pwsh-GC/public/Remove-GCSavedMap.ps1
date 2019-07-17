function Remove-GCSavedMap {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipeline)]
        [PSTypeName("GCSavedMap")]
        $Map,

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

        $Body = [PSCustomObject]@{
            action = "delete"
        }
    }
    process {
        foreach ($ThisMap in $Map) {
            $Uri = "/visibility/saved-maps/" + $ThisMap.id

            $Should = [string]$Uri
            if ( $PSCmdlet.ShouldProcess($Should, "pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key") ) {
                pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
            }
        }
    }
}

