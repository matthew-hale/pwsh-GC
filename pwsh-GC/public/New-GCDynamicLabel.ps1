function New-GCDynamicLabel {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [System.String]
        $LabelKey,

        [System.String]
        $LabelValue,

        [System.String]
        $Argument,

        [ValidateSet("name","numeric_ip_addresses","id")]
        [System.String]
        $Field,

        [ValidateSet("STARTSWITH","ENDSWITH","EQUALS","CONTAINS","SUBNET","WILDCARDS")]
        [System.String]
        $Operation,

        [Parameter(ValueFromPipeline)]
        [Array]
        $Criteria,

        [Switch]
        $Raw,

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
            $Uri = "/visibility/labels"
        }

        $Body = [PSCustomObject]@{
            id = $null
            key = $LabelKey
            value = $LabelValue
            criteria = @() #This is an array of "criteria objects" that can be specified by an array of these objects from the pipeline, via the $Criteria parameter. You can also create a rule with just a single criteria by directly specifying Argument, Field, and Operation.
        }
    }
    process {
        if ( -not ($LabelKey -and $LabelValue -and (($Argument -and $Field -and $Operation) -or $Criteria)) ) {
            throw "Parameters required: LabelKey, LabelValue, and either one or more Criteria objects, an Argument, Field, and Operation, or a label object"
        }
        if ( $Criteria ) {
            $Body.criteria += $Criteria
        } else {
            $Body.criteria += [PSCustomObject]@{
                argument = $Argument
                field = $Field
                op = $Operation
            }
        }
    }
    end {
        $Should = $Body.key + ": " + $Body.value
        if ( $PSCmdlet.ShouldProcess($Should, "pwsh-GC-get-request -Raw -Uri $Uri -ApiKey $Key") ) {
            pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
        }
    }
}

