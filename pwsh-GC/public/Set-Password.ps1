function Set-Password {
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipeline)]
        [Alias("Username","User")]
        [PSTypeName("GCUser")]$Name,

        [Parameter(Mandatory)]
        [String]$Password,

        [PSTypeName("GCApiKey")]$ApiKey
    )

    begin {
        if ( GCApiKey-present $ApiKey ) {
            if ( $ApiKey ) {
                $Key = $ApiKey
            } else {
                $Key = $global:GCApiKey
            }
            $Uri = "/system/user"
        }
    }

    process {
        foreach ( $ThisUser in $User ) {
            # Serialize/deserialize
            $RequestUser = $ThisUser | ConvertTo-Json -Depth 2 | ConvertFrom-Json

            $RequestUser | Add-Member -MemberType NoteProperty -Name "action" -Value "update"
            $RequestUser | Add-Member -MemberType NoteProperty -Name "password" -Value ($Password | ConvertFrom-SecureString)
            $RequestUser | Add-Member -MemberType NoteProperty -Name "password_confirm" -Value $Password
            $RequestBody = $RequestUser | Select-Object -Property action,can_access_passwords,description,email,id,permission_scheme_ids,two_factor_auth_enabled,username,password,password_confirm

            $Should = $ThisUser.username
            if ( $PSCmdlet.ShouldProcess($Should,"pwsh-GC-post-request -Raw -Uri $Uri -Method Post -ApiKey $Key") ) {
                pwsh-GC-post-request -Raw -Uri $Uri -Body $RequestBody -Method Post -ApiKey $Key
            }
        }
    }
}

