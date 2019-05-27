# Import the function
$here = (Split-Path -Parent $MyInvocation.MyCommand.Path)
. "$here/../Public/ConvertFrom-GCUnixTime.ps1"

Describe ConvertFrom-GCunixTime {
	It "Given a Unix timestamp in milliseconds, it returns the matching date as a DateTime object." {

		# Equivalent to Tuesday, February 12, 2019, 7:33:20 PM
		$Date = ConvertFrom-GCUnixTime -UnixTime 1550000000000

		$Date | Should -Be (get-date "2/12/2019 19:33:20").ToUniversalTime()
	}
}
