[cmdletbinding()]

param (
    [Parameter(ValueFromPipeline)]
    $EnrichedIncident,

    $ApiKey
)

begin {
    if ( $ApiKey ) {
        $Count = Get-GCPolicy -Section allow -Raw -ApiKey $ApiKey | Select-Object -ExpandProperty total_count
        $AllowPolicy = Get-GCPolicy -Section allow -Limit $Count -ApiKey $ApiKey
    } else {
        $Count = Get-GCPolicy -Section allow -Raw | Select-Object -ExpandProperty total_count
        $AllowPolicy = Get-GCPolicy -Section allow -Limit $Count
    }
}

process {
    foreach ( $Incident in $EnrichedIncident ) {
        $Flows = $Incident.flows
        
        foreach ( $Flow in $Flows ) {
            foreach ( $Policy in $AllowPolicy ) {
                $ = [PSCustomObject]@{
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

                # Source
                $SourceIP = $Flow.source_ip
                $SourceProcess = $Flow.source_process_name
            }
        }
    }
}

