function New-GCPolicy {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("allow","alert","block","override_allow","override_alert","override_block")]
        [string]
        $Section,

        [Parameter(Mandatory=$true)]
        [ValidateSet("allow","alert","block","block_and_alert")]
        [System.String]
        $Action,

        [ValidateSet("TCP","UDP")]
        [System.Array]
        $Protocol = @("TCP","UDP"),

        [ValidateRange(1,65535)]
        [System.Array]
        $Port,

        [System.Array]
        $PortRange,

        [System.Array]
        $SourceLabel,

        [System.Array]
        $DestinationLabel,

        [ValidateScript({
            if ( -not ($_ | Test-Path) ) {
                throw "Path does not exist."
            }
            if ( -not ($_ | Test-Path -PathType Leaf) ) {
                throw "Target must be a file."
            }
            $true
        })]
        [String[]]
        $SourceLabelFile,

        [ValidateScript({
            if ( -not ($_ | Test-Path) ) {
                throw "Path does not exist."
            }
            if ( -not ($_ | Test-Path -PathType Leaf) ) {
                throw "Target must be a file."
            }
            $true
        })]
        [String[]]
        $DestinationLabelFile,

        [System.Array]
        $SourceProcesses,

        [System.Array]
        $DestinationProcesses,

        [System.Array]
        $SourceAsset,

        [System.Array]
        $DestinationAsset,

        [string[]]
        $SourceSubnet,

        [string[]]
        $DestinationSubnet,

        [System.String]
        $Ruleset,

        [System.String]
        $Comments,

        [Switch]
        $SourceInternet,

        [Switch]
        $DestinationInternet,

        [PSTypeName("GCApiKey")]
        $ApiKey
    )
    
    if ( GCApiKey-present $ApiKey  ) {
        if ( $ApiKey ) {
            $Key = $ApiKey
        } else {
            $Key = $global:GCApiKey
        } 
        $Uri = "/visibility/policy/sections/" + $Section + "/rules"
    }

    if ( $SourceLabelFile ) {
        $SourceLabelIDs = Get-GCLabelIDFromFilePrivate -File $SourceLabelFile
    }
    
    if ( $DestinationLabelFile ) {
        $DestinationLabelIDs = Get-GCLabelIDFromFilePrivate -File $DestinationLabelFile
    }
    
    $ordering_value = $null #Required to be $null by the API call
    $ruleset_id = $null #Required to be $null by the API call
    
    $Body = [PSCustomObject]@{
        ordering_value = $ordering_value
        rule = [PSCustomObject]@{
            ruleset_id = $ruleset_id
            port_ranges = @()
            ports = @()
            source = [PSCustomObject]@{}
            destination = [PSCustomObject]@{}
            ip_protocols = $Protocol
            action = $Action
        }
    }
    
    if ( $Port ) {
        $Body.rule.ports = $Port
    }
    
    if ( $PortRange ) {
        #The validation doesn't work in ValidateScript for some reason, so I'm just doing it here
        foreach ($P in $PortRange) {
            if ( $P.length -ne 2 ) {
                throw "Parameter PortRange: Each range must consist of starting and ending port"
            }
            
            foreach ($Port in $P) {
                if ( -not (($Port -is [int]) -and ($Port -gt 0) -and ($Port -lt 65536)) ) {
                    throw "Parameter PortRange: Ports may only be integers from 1 to 65535"
                }
            }
            
            if ( $P[1] -le $P[0] ) {
                throw "Parameter PortRange: Each range's end value must be greater than its start value"
            }
            
            $port_range = [PSCustomObject]@{
                start = $P[0]
                end = $P[1]
            }
            
            $Body.rule.port_ranges += $port_range
        }
    }
    
    if ( $SourceLabel ) {
        $temp = [PSCustomObject]@{}
        $Body.rule.source | Add-Member -MemberType NoteProperty -Name labels -Value $temp
        $Body.rule.source.labels | Add-Member -MemberType NoteProperty -Name or_labels -Value @()
        
        $or_labels = @()
        
        foreach ($Group in $SourceLabel) {
            $and_labels = [PSCustomObject]@{
                and_labels = @()
            }
        
            foreach ($Item in $Group) {
                $and_labels.and_labels += $Item.id
            }
            
            $or_labels += $and_labels
        }
        
        $Body.rule.source.labels.or_labels = $or_labels
    }
    
    if ( $DestinationLabel ) {
        $temp = [PSCustomObject]@{}
        $Body.rule.destination | Add-Member -MemberType NoteProperty -Name labels -Value $temp
        $Body.rule.destination.labels | Add-Member -MemberType NoteProperty -Name or_labels -Value @()
        
        $or_labels = @()
        
        foreach ($Group in $DestinationLabel) {
            $and_labels = [PSCustomObject]@{
                and_labels = @()
            }
        
            foreach ($Item in $Group) {
                $and_labels.and_labels += $Item.id
            }
            
            $or_labels += $and_labels
        }
        
        $Body.rule.destination.labels.or_labels = $or_labels
    }
    
    if ( $SourceProcesses ) {
        $Body.rule.source | Add-Member -MemberType NoteProperty -Name processes -Value $SourceProcesses
    }
    
    if ( $DestinationProcesses ) {
        $Body.rule.destination | Add-Member -MemberType NoteProperty -Name processes -Value $DestinationProcesses
    }
    
    if ( $SourceAsset ) {
        $Body.rule.source | Add-Member -MemberType NoteProperty -Name asset_ids -Value @($SourceAsset.id)
    }
    
    if ( $DestinationAsset ) {
        $Body.rule.destination | Add-Member -MemberType NoteProperty -Name asset_ids -Value @($DestinationAsset.id)
    }
    
    if ( $SourceSubnet ) {
        $Body.rule.source | Add-Member -MemberType NoteProperty -Name subnets -Value $SourceSubnet
    }
    
    if ( $DestinationSubnet ) {
        $Body.rule.destination | Add-Member -MemberType NoteProperty -Name subnets -Value $DestinationSubnet
    }
    
    if ( $PSBoundParameters.ContainsKey("SourceInternet") ) { #checks for the existence of the parameter
        if ( $SourceInternet -eq $true ) {
            $Body.rule.source | Add-Member -MemberType NoteProperty -Name address_classification -Value "Internet"
        } elseif ( $SourceInternet -eq $false ) {
            $Body.rule.source | Add-Member -MemberType NoteProperty -Name address_classification -Value "Private"
        }
    }
    
    if ( $PSBoundParameters.ContainsKey("DestinationInternet") ) {
        if ( $DestinationInternet -eq $true ) {
            $Body.rule.destination | Add-Member -MemberType NoteProperty -Name address_classification -Value "Internet"
        } elseif ( $DestinationInternet -eq $false ) {
            $Body.rule.destination | Add-Member -MemberType NoteProperty -Name address_classification -Value "Private"
        }
    }
    
    if ( $Comments ) {
        $Body.rule | Add-Member -MemberType NoteProperty -Name comments -Value $Comments
    }
    
    if ( $Ruleset ) {
        $Body.rule | Add-Member -MemberType NoteProperty -Name ruleset_name -Value $Ruleset
    }
    
    $Should = $Ruleset
    if ( $PSCmdlet.ShouldProcess($Should, "pwsh-GC-post-request -Raw -Uri $Uri -ApiKey $Key") ) {
        pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
    }
}
