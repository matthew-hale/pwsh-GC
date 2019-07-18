Describe ConvertTo-GCunixTime {
    It "Given a datetime string, it returns a Unix timestamp in milliseconds." {

        # Equivalent to Tuesday, February 12, 2019, 7:33:20 PM
        $DateTime = Get-Date "02/12/2019 19:33:20" -Format (Get-Culture).DateTimeFormat.UniversalSortableDateTimePattern
        $Date = ConvertTo-GCUnixTime -DateTime $DateTime
        $Should = "1550000000000"

        $Date | Should -Be $Should
    }
}
