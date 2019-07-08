[cmdletbinding()]

param (
    [Parameter(ValueFromPipeline)]
    [PSTypeName("GCIncident")]
    $Incident,

    $ApiKey
)

begin {
}

process {
    foreach ( $ThisIncident in $Incident ) {
        $IncidentCopy = $ThisIncident | ConvertTo-Json -Depth 99 | ConvertFrom-Json

        $StartTime = ($IncidentCopy.start_time | ConvertFrom-GCUnixTime).AddSeconds(-5)
        $EndTime = ($IncidentCopy.end_time | ConvertFrom-GCUnixTime).AddSeconds(5)

        $AffectedAssetIPs = $IncidentCopy.affected_assets.ip

        if ( $ApiKey ) {
            $AffectedAssets = foreach ( $Asset in $AffectedAssetIPs ) {
                Get-GCAsset -Search $Asset -ApiKey $ApiKey
            }
            $Flows = Get-GCRawFlow -Limit 100 -StartTime $StartTime -EndTime $EndTime -AnySideAsset $AffectedAssets -ApiKey $ApiKey
        } else {
            $AffectedAssets = foreach ( $Asset in $AffectedAssetIPs ) {
                Get-GCAsset -Search $Asset
            }
            $Flows = Get-GCRawFlow -Limit 100 -StartTime $StartTime -EndTime $EndTime -AnySideAsset $AffectedAssets
        }

        $IncidentIDs = $IncidentCopy.flow_ids

        $MatchingFlows = foreach ( $ThisFlow in $Flows ) {
            if ( $IncidentIDs -Contains $ThisFlow.flow_id ) {
                $ThisFlow
            }
        }

        $IncidentCopy | Add-Member -MemberType NoteProperty -Name flows -Value $MatchingFlows -Force
        $IncidentCopy
    }
}

