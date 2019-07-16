function ConvertFrom-GCUnixTime {
    <#
        .ExternalHelp pwsh-GC-help.xml
    #>


    [cmdletbinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [Int64]
        $UnixDate
    )
    process {
        foreach ( $ThisUnixDate in $UnixDate ) {
            $Origin = New-Object DateTime 1970, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc)

            # Remember: GuardiCore works with epoch times in milliseconds
            $Origin.AddSeconds([Int]($ThisUnixDate/1000))
        }
    }
}

