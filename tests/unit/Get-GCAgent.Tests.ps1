Describe Get-GCAgent {
    Context "Simple function test" {
        Mock GCApiKey-present {
            $true
        }

        Mock pwsh-GC-get-request {
            param ($Uri)
            Invoke-RestMethod -Uri $Uri -Method "get"
        }

        Mock Invoke-RestMethod {
            param ($Method,$Uri)
            [PSCustomObject]@{
                Method = $Method
                Called = $true
                Uri = $Uri
            }
        }

        $Result = Get-GCAgent

        It "Successfully calls Invoke-RestMethod" {
            $Current = $Result.Called
            $Should = $true

            $Current | Should -Be $Should
        }

        It "Calls Invoke-RestMethod using a 'get' method" {
            $Current = $Result.Method
            $Should = "get"

            $Current | Should -Be $Should
        }

        It "Passes the correct Uri to pwsh-GC-get-request" {
            $Should = "/agents"
        }
    }
}

