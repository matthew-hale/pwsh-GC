# Import the function
. "$PWD/../pwsh-GC/Public/ConvertFrom-GCUnixTime.ps1"

Describe ConvertFrom-GCunixTime {
    It "Given a Unix timestamp in milliseconds, it returns the matching date." {

        # Equivalent to Tuesday, February 12, 2019, 7:33:20 PM
        $Date = ConvertFrom-GCUnixTime -UnixDate 1550000000000
        $Date = $Date.ToUniversalTime() -f "dd/mm/YYYY hh:MM:SS"
        $Should = "02/12/2019 19:33:20"

        $Date | Should -Be $Should
    }
}
