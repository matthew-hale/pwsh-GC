function New-GCDynamicLabel {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][System.String]$LabelKey,
		[Parameter(Mandatory=$false)][System.String]$LabelValue,
		[Parameter(Mandatory=$false)][System.String]$Argument,
		[Parameter(Mandatory=$false)][ValidateSet("name","numeric_ip_addresses")][System.String]$Field,
		[Parameter(Mandatory=$false)][ValidateSet("STARTSWITH","ENDSWITH","EQUALS","CONTAINS","SUBNET","WILDCARDS")][System.String]$Operation,
		[Parameter(Mandatory=$false,ValueFromPipeline = $true)][PSCustomObject]$Criteria
	)
	begin {
		$Key = $global:GCApiKey
		
		$Uri = $Key.Uri + "visibility/labels"
		
		$Body = [PSCustomObject]@{
			id = $null
			key = $LabelKey
			value = $LabelValue
			criteria = @() #This is an array of "criteria objects" that can be specified by an array of these objects from the pipeline, via the $Criteria parameter. You can also create a rule with just a single criteria by directly specifying Argument, Field, and Operation.
		}
	}
	process {
		if (-not ($LabelKey -and $LabelValue -and (($Argument -and $Field -and $Operation) -or $Criteria))) {
			throw "Parameters required: LabelKey, LabelValue, and either one or more Criteria objects, an Argument, Field, and Operation, or a label object"
		}
		if ($Criteria) {
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
		$BodyJson = $Body | ConvertTo-Json -Depth 99
		Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "POST"
	}
}
