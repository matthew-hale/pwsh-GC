function Get-ApiKey {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true,ParameterSetName = "ByName")]
        [System.String]
        $Server,

        [Parameter(Mandatory=$true,ParameterSetName = "ByUri")]
        [String]
        $Uri,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [Alias('Credentials','Cred')]
        [PSCredential]
        $Credential,

        [Switch]
        $Export
    )
    begin {
        if ( $Server ) {
            $Uri = "https://" + $Server + ".cloud.guardicore.com/api/v3.0"
        } else {
            $Uri = $Uri + "/api/v3.0"
        }
        $TempUri = $Uri + "/authenticate"
        $Body = [PSCustomObject]@{
            "username" = ""
            "password" = ""
        }
    }
    process {
        $Body.username = $Credential.UserName
        $Body.password = $Credential.GetNetworkCredential().Password
        $BodyJson = $Body | ConvertTo-Json -Depth 99

        if ( $pscmdlet.ShouldProcess("$Server","Invoke-RestMethod -Uri $TempUri -Method 'Post'") ) {
            try {
                $Token = Invoke-RestMethod -Uri $TempUri -Method "Post" -Body $BodyJson -ContentType "application/json" | Select-Object -ExpandProperty "access_token"
            }
            catch {
                throw $_.Exception
            }
        }

        if ( $Export ) {
            # Returns the object on the pipeline.

            [PSCustomObject]@{
                PSTypeName = "GCApiKey"
                Token = $Token
                Uri = $Uri
            }
        } else {
            # Saves the object in a global (session scope) variable called GCApiKey, so other functions don't need a key input.

            $Global:GCApiKey = [PSCustomObject]@{
                PSTypeName = "GCApiKey"
                Token = $Token
                Uri = $Uri
            }
        }
    }
}

