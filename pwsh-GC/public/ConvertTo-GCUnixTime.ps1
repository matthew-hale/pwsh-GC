function ConvertTo-GCUnixTime {
    <#
        .ExternalHelp pwsh-GC-help.xml
    #>


    [cmdletbinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [DateTime]
        $DateTime
    )
    process {
        foreach ( $ThisDateTime in $DateTime ) {
            $Origin = New-Object DateTime 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc)
            [Int64]($ThisDateTime.ToUniversalTime()-$Origin).TotalMilliseconds
        }
    }
}
