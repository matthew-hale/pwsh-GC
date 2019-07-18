function Get-GCRawFlow {
    [cmdletbinding()]
    param (
        [DateTime]
        $StartTime,

        [DateTime]
        $EndTime,

        [System.Array]
        $SourceProcess,

        [System.Array]
        $DestinationProcess,

        [System.Array]
        $AnySideProcess,

        [System.Array]
        $SourceAsset,

        [System.Array]
        $DestinationAsset,

        [System.Array]
        $AnySideAsset,

        [System.Array]
        $SourceLabel,

        [System.Array]
        $DestinationLabel,

        [System.Array]
        $AnySideLabel,

        [Switch]
        $SourceInternet,

        [Switch]
        $DestinationInternet,

        [Int32]
        $Limit = 20,

        [Int32]
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
        $Uri = "/connections?sort=slot_start_time"
    }

    # Handling default time values

    if ( -not $StartTime ) {
        $StartTime = $(Get-Date).AddHours(-1)
    }

    if ( -not $EndTime ) {
        $EndTime = Get-Date
    }

    # Building the request body


    $Body = @{
        from_time = (ConvertTo-GCUnixTime $StartTime)
        to_time = (ConvertTo-GCUnixTime $EndTime)
        offset = $Offset
        limit = $Limit
    }

    # Removing empty keys

    $RequestBody = Remove-EmptyKeys $Body

    # Legacy URI building

    ### Source ###

    if ( $SourceProcess -or $SourceAsset -or $SourceLabel -or $PSBoundParameters.ContainsKey("SourceInternat") ) {
        $Uri += "&source="
    }

    if ( $SourceInternet -eq $true ) {
        $Uri += "address_classification:Internet"
    } elseif ( $PSBoundParameters.ContainsKey("SourceInternet") -and ($SourceInternet -eq $false) ) {
        $Uri += "address_classification:Private"
    }

    if ( $SourceProcess ) {
        $Uri += "processes:"
        $Uri += $SourceProcess -Join ","
    }

    if ( $SourceAsset ) {
        $Uri += "assets:"
        $Uri += $SourceAsset.id -Join ","
    }

    if ( $SourceLabel ) { #2D array; outer group is OR, inner groups are AND
        $Uri += "labels:"
        foreach ($Group in $SourceLabel) {
            $Uri += $Group.id -Join ">"
            $Uri += "|"
        }

        $Uri = $Uri.SubString(0,$Uri.Length-1) #Removing last "|"
    }

    ### Destination ###

    if ( $DestinationProcess -or $DestinationAsset -or $DestinationLabel -or $PSBoundParameters.ContainsKey("DestinationInternet") ) {
        $Uri += "&destination="
    }

    if ( $DestinationInternet -eq $true ) {
        $Uri += "address_classification:Internet"
    } elseif ( $PSBoundParameters.ContainsKey("DestinationInternet") -and ($DestinationInternet -eq $false) ) {
        $Uri += "address_classification:Private"
    }

    if ( $DestinationProcess ) {
        $Uri += "processes:"
        $Uri += $DestinationProcess -Join ","
    }

    if ( $DestinationAsset ) {
        $Uri += "assets:"
        $Uri += $DestinationAsset.id -Join ","
    }

    if ( $DestinationLabel ) {
        $Uri += "labels:"
        foreach ($Group in $DestinationLabel) {
            $Uri += $Group.id -Join ">"
            $Uri += "|"
        }

        $Uri = $Uri.SubString(0,$Uri.Length-1) #Removing last "|"
    }

    ### Any Side ###

    if ( $AnySideProcess -or $AnySideAsset -or $AnySideLabel ) {
        $Uri += "&any_side="
    }

    if ( $AnySideProcess ) {
        $Uri += "processes:"
        $Uri += $AnySideProcess -Join ","
    }

    if ( $AnySideAsset ) {
        $Uri += "assets:"
        $Uri += $AnySideAsset.id -Join ","
    }

    if ( $AnySideLabel ) {
        $Uri += "labels:"
        foreach ($Group in $AnySideLabel) {
            $Uri += $Group.id -Join ">"
            $Uri += "|"
        }
        $Uri = $Uri.SubString(0,$Uri.Length-1) #Removing last "|"
    }

    if ( $Raw ) {
        pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
    } else {
        pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCRawFlow"); $_}
    }
}

