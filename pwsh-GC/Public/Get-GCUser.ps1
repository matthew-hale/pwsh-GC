function Get-GCUser {
    [cmdletbinding()]

    param (
        [String[]]
        $Name,

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

    foreach ( $ThisName in $Name ) {
        $Body = @{
            username = $ThisName
        }

        $RequestBody = Remove-EmptyKeys $Body
    
        if ( $Raw ) {
            pwsh-gc-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
        } else {
            pwsh-gc-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCUser"); $_}
            
        }
    }
}
