# Import the function
. "$PWD/../pwsh-GC/Public/Get-GCAgent.ps1"

# Import private functions
. "$PWD/../pwsh-GC/Private/pwsh-GC-get-request.ps1"
. "$PWD/../pwsh-GC/Private/GCApiKey-present.ps1"
. "$PWD/../pwsh-GC/Private/Remove-EmptyKeys.ps1"

# Import test function
. "$PWD/functions/unrollhash.ps1"

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
			$ShouldData = @{
				limit = 20
				offset = 0
			}
			$Should = unrollhash $ShouldData
			$Test = unrollhash $Result[1]
			$Test | Should -Be $Should
		}
	
		It "calls pwsh-GC-get-request with the correct ApiKey" {
			$Should = $global:GCApiKey.Uri + " " + (New-Object PSCredential "user",$global:GCApiKey.Token).GetNetworkCredential().Password
			$Test = $Result[2].Uri + " " + (New-Object PSCredential "user",$Result[2].Token).GetNetworkCredential().Password
			$Test | Should -Be $Should
		}

		$global:GCApiKey = $Hold
	}

	Context "Raw switch" {
		Mock pwsh-GC-get-request {
			@($Uri,$Body,$ApiKey,$Raw)
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
	
		$Result = Get-GCAgent -Raw

		It "calls pwsh-GC-get-request with the correct Uri" {
			$Should = "/agents"
			$Result[0] | Should -Be $Should
		}
	
		It "calls pwsh-GC-get-request with the correct Body" {
			$ShouldData = @{
				limit = 20
				offset = 0
			}
			$Should = unrollhash $ShouldData
			$Test = unrollhash $Result[1]
			$Test | Should -Be $Should
		}
	
		It "calls pwsh-GC-get-request with the correct ApiKey" {
			$Should = $global:GCApiKey.Uri + " " + (New-Object PSCredential "user",$global:GCApiKey.Token).GetNetworkCredential().Password
			$Test = $Result[2].Uri + " " + (New-Object PSCredential "user",$Result[2].Token).GetNetworkCredential().Password
			$Test | Should -Be $Should
		}

		It "calls pwsh-GC-get-request with the Raw switch" {
			$Result[3] | Should -Be $true
		}

		$global:GCApiKey = $Hold
	}

	Context "Simple input: -Limit 100 -Offset 50 -Search testsearch" {
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
			$ShouldData = @{
				limit = 100
				offset = 50
				"gc_filter" = "testsearch"
			}
			$Should = unrollhash $ShouldData
			$Test = unrollhash $Result[1]
			$Test | Should -Be $Should
			$Test | Should -Be $Should
		}

		It "calls pwsh-GC-get-request with the correct ApiKey" {
			$Should = $global:GCApiKey.Uri + " " + (New-Object PSCredential "user",$global:GCApiKey.Token).GetNetworkCredential().Password
			$Test = $Result[2].Uri + " " + (New-Object PSCredential "user",$Result[2].Token).GetNetworkCredential().Password
			$Test | Should -Be $Should
		}

		$global:GCApiKey = $Hold
	}

	Context "Complex input: all non-GuardiCore object params" {
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

		$Result = Get-GCAgent -Limit 130 -Offset 500 -OS "Linux" -Status "Online" -Flag @(2..4) -Enforcement "Active" -Deception "Active" -Detection "Active" -Reveal "Active" -Activity "last_month"

		It "calls pwsh-GC-get-request with the correct Uri" {
			$Should = "/agents"
			$Result[0] | Should -Be $Should
		}

		It "calls pwsh-GC-get-request with the correct Body" {
			$ShouldData = [ordered]@{
				limit = 130
				offset = 500
				os = "Linux"
				display_status = "Online"
				status_flags = "2,3,4"
				module_status_deception = "Active"
				module_status_detection = "Active"
				module_status_reveal = "Active"
				module_status_enforcement = "Active"
				activity = "last_month"
			}
			$Should = unrollhash $ShouldData
			$Test = unrollhash $Result[1]
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
