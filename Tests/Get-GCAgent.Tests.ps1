# Import the function
. "$PWD/../pwsh-GC/Public/Get-GCAgent.ps1"

# Import private functions
. "$PWD/../pwsh-GC/Private/pwsh-GC-get-request.ps1"
. "$PWD/../pwsh-GC/Private/GCApiKey-present.ps1"
. "$PWD/../pwsh-GC/Private/Remove-EmptyKeys.ps1"

Describe Get-GCAgent {
	Context "No input" {
		Mock pwsh-GC-get-request {
			@($Uri,$Body,$ApiKey)
		}
	
		Mock GCApiKey-present {
			$true
		}

		if ($global:GCApiKey) {
			$Hold = $global:GCApiKey
		} else {
			$Hold = $null
		}

		$global:GCApiKey = [PSCustomObject]@{
			PSTypeName = "GCApiKey"
			Token = (ConvertTo-SecureString "testtoken" -AsPlainText -Force)
			Uri = "testuri"
		}
	
		$Result = Get-GCAgent

		It "calls pwsh-GC-get-request with the correct Uri" {
			$Should = "/agents"
			$Result[0] | Should -Be $Should
		}
	
		It "calls pwsh-GC-get-request with the correct Body" {
			$Should = @{
				limit = 20
				offset = 0
			}
			$Should = [string]$Should["limit"] + " " + [string]$Should["offset"]
			$Test = [string]$Result[1]["limit"] + " " + [string]$Result[1]["offset"]
			$Test | Should -Be $Should
		}
	
		It "calls pwsh-GC-get-request with the correct ApiKey" {
			$Should = $global:GCApiKey.Uri + " " + (New-Object PSCredential "user",$global:GCApiKey.Token).GetNetworkCredential().Password
			$Test = $Result[2].Uri + " " + (New-Object PSCredential "user",$Result[2].Token).GetNetworkCredential().Password
			$Test | Should -Be $Should
		}

		$global:GCApiKey = $Hold
	}

	Context "Simple input" {
		Mock pwsh-GC-get-request {
			@($Uri,$Body,$ApiKey)
		}
	
		Mock GCApiKey-present {
			$true
		}

		if ($global:GCApiKey) {
			$Hold = $global:GCApiKey
		} else {
			$Hold = $null
		}

		$global:GCApiKey = [PSCustomObject]@{
			PSTypeName = "GCApiKey"
			Token = (ConvertTo-SecureString "testtoken" -AsPlainText -Force)
			Uri = "testuri"
		}

		$Result = Get-GCAgent -Limit 100 -Offset 50 -Search "testsearch"

		It "calls pwsh-GC-get-request with the correct Uri" {
			$Should = "/agents"
			$Result[0] | Should -Be $Should
		}

		It "calls pwsh-GC-get-request with the correct Body" {
			$Should = @{
				limit = 100
				offset = 50
				search = "testsearch"
			}
			$Should = [string]$Should["limit"] + " " + [string]$Should["offset"] + " " + [string]$Should["search"]
			$Test = [string]$Result[1]["limit"] + " " + [string]$Result[1]["offset"] + " " + [string]$Result[1]["search"]
			$Test | Should -Be $Should
		}

		It "calls pwsh-GC-get-request with the correct ApiKey" {
			$Should = $global:GCApiKey.Uri + " " + (New-Object PSCredential "user",$global:GCApiKey.Token).GetNetworkCredential().Password
			$Test = $Result[2].Uri + " " + (New-Object PSCredential "user",$Result[2].Token).GetNetworkCredential().Password
			$Test | Should -Be $Should
		}

		$global:GCApiKey = $Hold
	}
}
