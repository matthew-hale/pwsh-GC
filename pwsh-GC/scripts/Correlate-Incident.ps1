[cmdletbinding()]

param (
    [Parameter(ValueFromPipeline)]
    $EnrichedIncident,

    $ApiKey
)

begin {
    $Count = Get-GCPolicy -Section allow -Raw -ApiKey $ApiKey | Select-Object -ExpandProperty total_count
    $AllowPolicy = Get-GCPolicy -Section allow -Limit $Count -ApiKey $ApiKey
}

process {
    foreach ( $Incident in $EnrichedIncident ) {
        $Flows = $Incident.flows
        
        foreach ( $Flow in $Flows ) {
            foreach ( $Policy in $AllowPolicy ) {
                $Result = [PSCustomObject]@{
                    incident_id = $Incident.id
                    flow_id = $Flow.flow_id
                    policy_id = $Policy.id
                    source = $false
                    source_process = $false
                    destination = $false
                    destination_process = $false
                    ports = $false
                    Different = 5
                }

                # Source Asset

                $SourceIP = $Flow.source_ip
                $SourceAsset = Get-GCAsset -Search $SourceIP
                $PolicySource = $Policy.source



                    <#
                    # if the flow asset is in any of the and groups
                    $LabelResults = foreach ( $AndGroup in $PolicySource.labels.or_labels ) {
                        $SourceLabelMatch = $true

                        foreach ( $PolicyLabel in $AndGroup ) {
                            if ( $SourceAsset.labels.id -notcontains $PolicyLabel.id ) {
                                $SourceLabelMatch = $false
                            }
                        }

                        $SourceLabelMatch
                    }

                    if ( $LabelResults -contains $true ) {
                        $Result.source = $SourceLabelMatch
                        $Result.Different -= 1
                    }
                    #>


                
                # If any of the defined label groups contain the flow asset,
                # or if any of the defined assets match the flow asset,
                # or if any of the defined subnets contain the flow IP
                if ( $PolicySource.labels ) {
                } elseif ( $PolicySource.assets ) {
                } elseif ( $PolicySource.subnets ) {
                }

                # Source Process

                $SourceProcess = $Flow.source_process_name
                $PolicySourceProcess = $PolicySource.processes

                # If any of the policy processes match the flow process
                if ( $PolicySourceProcess -and ($PolicySourceProcess -match $SourceProcess) ) {
                    $Result.source_process = $true
                    $Result.Different -= 1
                }
            }
        }
    }
}

