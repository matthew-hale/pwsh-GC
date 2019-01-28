#Encapsulates the "PUT visibility/policy/rules/{ruleID}" API call

function Set-GCPolicy {
	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false,ValueFromPipeline=$true)]$Policy #One or more policy objects as returned from GuardiCore, but with updated values. Accepts the PS object, not JSON data. This allows you to grab a policy, change it via powershell methods, and pass it into this function to update it.
	)
	begin {
		$Key = $global:GCApiKey
		$Result = @()
	}
	process {
		$Result += foreach ($P in $Policy) {
			$PCopy = $P | ConvertTo-Json -Depth 99 | ConvertFrom-Json
			$Uri = $Key.Uri + "visibility/policy/rules/" + $PCopy.id
			
			#Have to parse the source/destination labels to only contain IDs instead of all the other info that they come with from Get-GCLabel
			#Passing that extra info to the API errors out, because this api call is just like the one for creating new policy, and only uses label IDs for the source/destination
			
			if ($PCopy.source.labels) {
				$OrCount = $PCopy.source.labels.or_labels.count
				for ($i = 0; $i -lt $OrCount; $i++) {
					$AndCount = $PCopy.source.labels.or_labels[$i].and_labels.count
					for ($j = 0; $j -lt $AndCount; $j++) {
						$temp = $PCopy.source.labels.or_labels[$i].and_labels[$j].id
						$PCopy.source.labels.or_labels[$i].and_labels[$j] = $temp
					}
				}
			}
			
			if ($PCopy.destination.labels) {
				$OrCount = $PCopy.destination.labels.or_labels.count
				for ($i = 0; $i -lt $OrCount; $i++) {
					$AndCount = $PCopy.destination.labels.or_labels[$i].and_labels.count
					for ($j = 0; $j -lt $AndCount; $j++) {
						$temp = $PCopy.destination.labels.or_labels[$i].and_labels[$j].id
						$PCopy.destination.labels.or_labels[$i].and_labels[$j] = $temp
					}
				}
			}
			
			$BodyJson = $PCopy | ConvertTo-Json -Depth 99
			Invoke-RestMethod -Uri $Uri -ContentType "application/json" -Authentication Bearer -Token $Key.Token -Body $BodyJson -Method "PUT"
		}
	}
	end {
		$Result
	}
}
