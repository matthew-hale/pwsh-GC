function Publish-GCPolicy {
    [CmdletBinding(SupportsShouldProcess)]

    param(
        [Parameter(Mandatory)]
        [System.String]
        $Comments,

        [Switch]
        $Audit,

        [PSTypeName("GCApiKey")]
        $ApiKey
    )

    if ( GCApiKey-present $ApiKey ) {
        if ( $ApiKey ) {
            $Key = $ApiKey
        } else {
            $Key = $global:GCApiKey
        } 
        $Uri = "/visibility/policy/revisions"
    }
    
    # Building the request body from parameters

    $Body = [PSCustomObject]@{
        action = "publish"
        comments = $Comments
    }
    
    if ( $PSCmdlet.ShouldProcess($Body, "pwsh-GC-post-request -Raw -Uri $Uri -ApiKey $Key") ) {
        pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
    }
}

