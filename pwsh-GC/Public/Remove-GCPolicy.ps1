function Remove-GCPolicy {
    [CmdletBinding(SupportsShouldProcess)]

    param (
        [Parameter(ValueFromPipeline)]
        [System.Array]
        $Policy,

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
        foreach ($ThisPolicy in $Policy) {
            $Uri = "/visibility/policy/rules/" + $ThisPolicy.id
            
            if ( $PSCmdlet.ShouldProcess($ThisPolicy, "pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key") ) {
                pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
            }
        }
    }
}
