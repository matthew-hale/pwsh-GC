function Get-GCUser {
    <#
        .ExternalHelp pwsh-GC-help.xml
    #>


    [cmdletbinding()]
    param (
        [String[]]
        $Name,

        [int]
        $Limit = 20,

        [int]
        $Offset,

        [Switch]
        $Raw,

        [PSTypeName("GCApiKey")]
        $ApiKey
    )

    if ( GCApiKey-present $ApiKey ) {
        if ( $ApiKey ) {
            $Key = $ApiKey
        } else {
            $Key = $global:GCApiKey
        } 
        $Uri = "/system/users"
    }

    $Body = @{
        username = $Name -join ","
        limit = $Limit
        offset = $Offset
    }

    $RequestBody = Remove-EmptyKeys $Body

    if ( $Raw ) {
        pwsh-gc-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
    } else {
        pwsh-gc-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCUser"); $_}
        
    }
}
