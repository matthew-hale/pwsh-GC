function Get-GCAsset {

    [CmdletBinding()]
    param (
        [System.String]
        $Search,

        [ValidateSet("on","off")]
        [System.String]
        $Status,

        [ValidateSet("0","1","2","3")]
        [string[]]
        $Risk,

        [Parameter(Mandatory=$false,ValueFromPipeline=$true)]
        [PSTypeName("GCLabel")]
        $Label,

        [Alias("Assets","ID")]
        $Asset,

        [ValidateRange(0,1000)]
        [Int32]$Limit = 20,

        [ValidateRange(0,500000)]
        [Int32]$Offset,

        [Switch]$Raw,

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
            $Uri = "/assets"
        }
    }

    process {
        # Handling pipeline input
        $LabelIDs = foreach ($L in $Label) {
            $L.id
        }

        $Body = @{
            search = $Search
            status = $Status
            risk_level = $Risk
            labels = $LabelIDs -join ","
            asset = ""
            limit = $Limit
            offset = $Offset
        }

        # Handling strange asset case

        if ( $Asset ) {
            if ( $Asset[0].id ) {
                $Body.asset = "vm:" + $Asset[0].id
            } else {
                $Body.asset = "vm:" + $Asset
            }
        }

        # Removing empty hashtable keys
        $RequestBody = Remove-EmptyKeys $Body

        # Making the call
        if ( $Raw ) {
            pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
        } else {
            pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCAsset"); $_}
        }
    }
}

