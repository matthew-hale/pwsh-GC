function Set-GCPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipeline)]
        [PSTypeName("GCPolicy")]
        $Policy,

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
        }
    }
    process {
        foreach ($ThisPolicy in $Policy) {
            # Serialize/deserialize data
            $PCopy = $ThisPolicy | ConvertTo-Json -Depth 99 | ConvertFrom-Json
            $Uri = "/visibility/policy/rules/" + $PCopy.id

            # Have to parse the source/destination labels to only contain IDs,
            # instead of all the other info that they come with from Get-GCLabel
            # Passing that extra info to the API errors out,
            # because this api call is just like the one for creating new policy,
            # and only uses label IDs for the source/destination

            if ( $PCopy.source.labels ) {
                $OrCount = $PCopy.source.labels.or_labels.count
                for ($i = 0; $i -lt $OrCount; $i++) {
                    $AndCount = $PCopy.source.labels.or_labels[$i].and_labels.count
                    for ($j = 0; $j -lt $AndCount; $j++) {
                        $temp = $PCopy.source.labels.or_labels[$i].and_labels[$j].id
                        $PCopy.source.labels.or_labels[$i].and_labels[$j] = $temp
                    }
                }
            }

            if ( $PCopy.destination.labels ) {
                $OrCount = $PCopy.destination.labels.or_labels.count
                for ($i = 0; $i -lt $OrCount; $i++) {
                    $AndCount = $PCopy.destination.labels.or_labels[$i].and_labels.count
                    for ($j = 0; $j -lt $AndCount; $j++) {
                        $temp = $PCopy.destination.labels.or_labels[$i].and_labels[$j].id
                        $PCopy.destination.labels.or_labels[$i].and_labels[$j] = $temp
                    }
                }
            }

            $RequestBody = $PCopy

            $Should = $RequestBody.ruleset_name
            if ( $PSCmdlet.ShouldProcess($Should,"pwsh-GC-post-request -Raw -Uri $Uri -Method Put -ApiKey $Key") ) {
                pwsh-GC-post-request -Raw -Uri $Uri -Body $RequestBody -Method Put -ApiKey $Key
            }
        }
    }
}
