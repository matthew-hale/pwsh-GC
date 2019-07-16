function New-GCBlankLabel {
    <#
        .ExternalHelp pwsh-GC-help.xml
    #>


    [cmdletbinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [String]
        $LabelKey,

        [Parameter(Mandatory)]
        [String]
        $LabelValue,

        [PSTypeName("GCApiKey")]
        $ApiKey
    )

    if ( GCApiKey-present $ApiKey ) {
        if ( $ApiKey ) {
            $Key = $ApiKey
        } else {
            $Key = $global:GCApiKey
        } 
        $Uri = "/visibility/labels"
    }

    $Body = [PSCustomObject]@{
        id = $null
        key = $LabelKey
        value = $LabelValue
        criteria = @()
    }

    $Should = $Body.key + ": " + $Body.value
    if ( $PSCmdlet.ShouldProcess($Should,"pwsh-GC-post-request on $Uri with $Key") ) {
        pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
    }
}
