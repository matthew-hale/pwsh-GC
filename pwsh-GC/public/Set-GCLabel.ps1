<#
    .ExternalHelp pwsh-GC-help.xml
#>


function Set-GCLabel {
    [CmdletBinding(SupportsShouldProcess)]
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

            $Should = $Uri
            if ( $PSCmdlet.ShouldProcess($Should, "pwsh-GC-post-request -Raw -Uri $Uri -Method Put -ApiKey $Key") ) {
                pwsh-GC-post-request -Raw -Uri $Uri -Body $RequestBody -Method Put -ApiKey $Key
            }
        }
    }
}

