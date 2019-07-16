<#
    .ExternalHelp pwsh-GC-help.xml
#>


function Publish-GCPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [System.String]
        $Comments,

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
    
    $Should = $Body.action
    if ( $PSCmdlet.ShouldProcess($Should, "pwsh-GC-post-request -Raw -Uri $Uri -ApiKey $Key") ) {
        pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
    }
}

