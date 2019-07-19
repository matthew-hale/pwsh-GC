function Get-GCPolicy {
    [CmdletBinding()]
    param (
        [System.String]
        $Search,

        [ValidateSet("allow","alert","block","override","override_allow","override_alert","override_block")]
        [System.String[]]
        $Section = @("allow","alert","block"),

        [ValidateSet("UNCHANGED","CREATED","MODIFIED","DELETED")]
        [string[]]
        $State,

        [ValidateSet("TCP","UDP")]
        [System.Array]
        $Protocol = @("TCP","UDP"),

        [ValidateRange(1,65535)]
        [System.Array]
        $Port,

        [PSTypeName("GCLabel")]
        $SourceLabel,

        [PSTypeName("GCLabel")]
        $DestinationLabel,

        [PSTypeName("GCLabel")]
        $AnySideLabel,

        [System.Array]
        $SourceProcess,

        [System.Array]
        $DestinationProcess,

        [System.Array]
        $AnySideProcess,

        [PSTypeName("GCAsset")]
        $SourceAsset,

        [PSTypeName("GCAsset")]
        $DestinationAsset,

        [PSTypeName("GCAsset")]
        $AnySideAsset,

        [ValidateScript({
            foreach ($Subnet in $_) {
                if ( -not ($Subnet -match "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/([1-9]|[1-2][0-9]|[3][0-2])") ) {
                    throw "The subnet provided is not a valid subnet. Please provide a subnet in 0.0.0.0/0 format."
                }

                $true
            }
        })]
        [System.Array]
        $SourceSubnet,

        [ValidateScript({
            foreach ($Subnet in $_) {
                if ( -not ($Subnet -match "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/([1-9]|[1-2][0-9]|[3][0-2])") ) {
                    throw "The subnet provided is not a valid subnet. Please provide a subnet in 0.0.0.0/0 format."
                }

                $true
            }
        })]
        [System.String]
        $DestinationSubnet,

        [ValidateScript({
            foreach ($Subnet in $_) {
                if ( -not ($Subnet -match "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/([1-9]|[1-2][0-9]|[3][0-2])") ) {
                    throw "The subnet provided is not a valid subnet. Please provide a subnet in 0.0.0.0/0 format."
                }

                $true
            }
        })]
        [System.String]
        $AnySideSubnet,

        [System.String]
        $Ruleset,

        [System.String]
        $Comments,

        [Switch]
        $SourceInternet,

        [Switch]
        $DestinationInternet,

        [Switch]
        $AnySideInternet,

        [ValidateRange(0,1000)]
        [Int32]
        $Limit = 20,

        [ValidateRange(0,500000)]
        [Int32]
        $Offset = 0,

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
        $Uri = "/visibility/policy/rules?limit=" + $Limit
    }

    # Building the request body with given parameters

    $Body = @{
        sections = $Section -join ","
        protocols = $Protocol -join ","
        offset = $Offset
        search = $Search
        comments = $Comments
        ruleset = $Ruleset
        state = $State
        port = $Port -join ","
    }

    # Removing empty keys

    $RequestBody = Remove-EmptyKeys $Body

    # Legacy URI building

    ##### SOURCES #####

    $Uri += "&source="

    if ( $SourceLabel ) {
        $Uri += "labels:"
        foreach ($Group in $SourceLabel) {
            $Uri += $Group.id -join ">"
            $Uri += "|"
        }

        $Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"

        $Uri += ","
    }

    if ( $SourceProcess ) {
        $Uri += "processes:"
        $Uri += $SourceProcess -join "|"

        $Uri += ","
    }

    if ( $SourceAsset ) {
        $Uri += "assets:"
        $Uri += $SourceAsset.id + "|"

        $Uri += ","
    }

    if ( $SourceSubnet ) {
        $Uri += "subnet:" + $SourceSubnet + ","
    }

    if ( $PSBoundParameters.ContainsKey("SourceInternet") ) { #checks for the existence of the parameter
        if ( $SourceInternet -eq $true ) {
            $Uri += "address_classification:Internet,"
        } elseif ( $SourceInternet -eq $false ) {
            $Uri += "address_classification:Private,"
        }
    }

    #If any above parameter was present, remove the trailing ","; if nothing above was present, remove "source="
    if ( $Uri.SubString($Uri.length-1) -eq "," ) {
        $Uri = $Uri.SubString(0,$Uri.length-1)
    } else {
        $Uri = $Uri.SubString(0,$Uri.length-8)
    }

    ###################

    ##### DESTINATIONS #####

    $Uri += "&destination="

    if ( $DestinationLabel ) {
        $Uri += "labels:"
        foreach ($Group in $DestinationLabel) {
            $Uri += $Group.id -join ">"

            $Uri += "|"
        }

        $Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"

        $Uri += ","
    }

    if ( $DestinationProcesses ) {
        $Uri += "processes:"
        $Uri += $DestinationProcesses -join "|"

        $Uri += ","
    }

    if ( $DestinationAsset ) {
        $Uri += "assets:"
        $Uri += $DestinationAsset.id -join "|"

        $Uri += ","
    }

    if ( $DestinationSubnet ) {
        $Uri += "subnet:" + $DestinationSubnet + ","
    }

    if ( $PSBoundParameters.ContainsKey("DestinationInternet") ) {
        if ( $DestinationInternet -eq $true ) {
            $Uri += "address_classification:Internet,"
        } elseif ( $DestinationInternet -eq $false ) {
            $Uri += "address_classification:Private,"
        }
    }

    #If any above parameter was present, remove the trailing ","; if nothing above was present, remove "&destination="
    if ( $Uri.SubString($Uri.length-1) -eq "," ) {
        $Uri = $Uri.SubString(0,$Uri.length-1)
    } else {
        $Uri = $Uri.SubString(0,$Uri.length-13)
    }

    ########################

    ##### ANY SIDE #####

    $Uri += "&any_side="

    if ( $AnySideLabel ) {
        $Uri += "labels:"
        foreach ($Group in $AnySideLabel) {
                $Uri += $Group.id -join ">"
                $Uri += "|"
        }

        $Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"

        $Uri += ","
    }

    if ( $AnySideProcesses ) {
        $Uri += "processes:"
        foreach ($Process in $AnySideProcesses) {
            $Uri += $Process + "|"
        }

        $Uri = $Uri.SubString(0,$Uri.length-1) #Remove trailing "|"

        $Uri += ","
    }

    if ( $AnySideAsset ) {
        $Uri += "assets:"
        $Uri += $AnySideAsset -join "|"

        $Uri += ","
    }

    if ( $AnySideSubnet ) {
        $Uri += "subnet:" + $AnySideSubnet + ","
    }

    if ( $PSBoundParameters.ContainsKey("AnySideInternet") ) { #checks for the existence of the parameter
        if ( $AnySideInternet -eq $true ) {
            $Uri += "address_classification:Internet,"
        } elseif ( $AnySideInternet -eq $false ) {
            $Uri += "address_classification:Private,"
        }
    }

    #If any above parameter was present, remove the trailing ","; if nothing above was present, remove "&any_side="
    if ( $Uri.SubString($Uri.length-1) -eq "," ) {
        $Uri = $Uri.SubString(0,$Uri.length-1)
    } else {
        $Uri = $Uri.SubString(0,$Uri.length-10)
    }

    ####################

    # Make the call

    if ( $Raw ) {
        pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
    } else {
        pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCPolicy"); $_}
    }
}

