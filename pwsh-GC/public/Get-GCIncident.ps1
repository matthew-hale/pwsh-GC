function Get-GCIncident{
    [CmdletBinding()]
    param (
        [DateTime]
        $StartTime,

        [DateTime]
        $EndTime,

        [ValidateSet("Low","Medium","High")]
        [System.String[]]
        $Severity,

        [ValidateSet("Incident","Deception","Network Scan","Reveal","Experimental")]
        $IncidentType,

        [String]
        $SourceAsset,

        [String]
        $DestinationAsset,

        [String]
        $AnySideAsset,

        [PSTypeName("GCLabel")]
        $SourceLabel,

        [PSTypeName("GCLabel")]
        $DestinationLabel,

        [PSTypeName("GCLabel")]
        $AnySideLabel,

        [System.Array]
        $IncludeTag,

        [System.Array]
        $ExcludeTag,

        [ValidateRange(0,1000)]
        $Limit = 20,

        [ValidateRange(0,500000)]
        [Int32]
        $Offset = 0,

        [String]
        $ID,

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
        # This sort is required for legacy URI building
        $Uri = "/incidents?sort=-start_time"
    }

    # Handling start and end time defaults

    if ( -not $StartTime ) {
        $StartTime = $(Get-Date).AddHours(-1)
    }

    if ( -not $EndTime ) {
        $EndTime = Get-Date
    }

    [Int64]$StartTime = $StartTime | ConvertTo-GCUnixTime
    [Int64]$EndTime = $EndTime | ConvertTo-GCUnixTime

    # Building request body with parameters

    $Body = @{
        from_time = $StartTime
        to_time = $EndTime
        severity = $Severity
        incident_type = $IncidentType
        tag = $IncludeTag -join ","
        tags__not = $ExcludeTag -join ","
        id = $ID
        limit = $Limit
        offset = $Offset
    }

    # Removing empty keys

    $RequestBody = Remove-EmptyKeys $Body


    # This legacy URI building is actually necessary,
    # due to the complicated way in which the URI needs to be structured.
    ### SOURCE ###

    $Uri += "&source="

    if ( $SourceLabel ) {
        $Uri += "labels:"
        $Uri += $SourceLabel.id -join "|"
    }

    if ( $SourceAsset ) {
        $Uri += "assets:"
        $Uri += $SourceAsset -join ","
    }

    if ( $Uri[$Uri.length-1] -eq "=" ) {
        $Uri = $Uri.SubString(0,$Uri.Length-8)
    }

    ### DESTINATION ###

    $Uri += "&destination="

    if ( $DestinationLabel ) {
        $Uri += "labels:"
        $Uri += $DestinationLabel.id -join "|"
    }

    if ( $DestinationAsset ) {
        $Uri += "assets:"
        $Uri += $DestinationAsset -join ","
    }

   if ( $Uri[$Uri.length-1] -eq "=" ) {
        $Uri = $Uri.SubString(0,$Uri.Length-13)
    }

    ### ANY SIDE ###
    $Uri += "&any_side="

    if ( $AnySideLabel ) {
        $Uri += "labels:"
        $Uri += $AnySideLabel.id -join "|"
    }

    if ( $AnySideAsset ) {
        $Uri += "assets:"
        $Uri += $AnySideAsset -join ","
    }

    if ( $Uri[$Uri.length-1] -eq "=" ) {
        $Uri = $Uri.SubString(0,$Uri.Length-10)
    }

    # Making the call

    if ( $Raw ) {
        pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
    } else {
        pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCIncident"); $_}
    }
}
