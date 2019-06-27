function New-GCSavedMap{
    
    [CmdletBinding()]
    param (
        [System.String]
        $Name,

        [Switch]
        $Public,

        [HashTable]
        $FilterHashTableInclude,

        [HashTable]
        $FilterHashTableExclude,

        [DateTime]
        $StartTime,

        [DateTime]
        $EndTime,

        [System.Array]
        $TimeRange,

        [Switch]
        $IncludeProcesses,

        [Switch]
        $TimeResolution,

        [Switch]
        $EmailOnProgress,

        [PSTypeName("GCApiKey")]
        $ApiKey
    )

    if ( GCApiKey-present $ApiKey ) {
        if ( $ApiKey ) {
            $Key = $ApiKey
        } else {
            $Key = $global:GCApiKey
        } 
        $Uri = "/visibility/saved-maps"
    }
    
    # Building the request body based on parameters

    $Body = [PSCustomObject]@{
        name = ""
        map_type = 1
        filters = [PSCustomObject]@{}
        start_time_filter = $null
        end_time_filter = $null
        include_processes = $IncludeProcesses.IsPresent
        time_resolution = $TimeResolution.IsPresent
        email_on_progress = $EmailOnProgress.IsPresent
    }
    
    if ( -not $StartTime ) {
        $Body.start_time_filter = $($(Get-Date).AddHours(-1) | ConvertTo-GCUnixTime)
    } else {
        $Body.start_time_filter = $StartTime | ConvertTo-GCUnixTime
    }
    
    if ( -not $EndTime ) {
        $Body.end_time_filter = $(Get-Date | ConvertTo-GCUnixTime)
    } else {
        $Body.end_time_filter = $EndTime | ConvertTo-GCUnixTime
    }
    
    if ( $Name ) {
        $Body.name = $Name
    }
    
    if ( $Public ) {
        $Body.map_type = 0
    }
    
    if ( $FilterHashTableInclude ) {
        $temp = [PSCustomObject]@{}
        $Body.filters | Add-Member -MemberType NoteProperty -Name include -Value $temp
        foreach ($Hash in $FilterHashTableInclude.Keys) {
            $Body.filters.include | Add-Member -MemberType NoteProperty -Name $Hash -Value @($FilterHashTableInclude[$Hash])
        }
    }
    
    if ( $FilterHashTableExclude ) {
        $temp = [PSCustomObject]@{}
        $Body.filters | Add-Member -MemberType NoteProperty -Name exclude -Value $temp
        foreach ($Hash in $FilterHashTableExclude.Keys) {
            $Body.filters.exclude | Add-Member -MemberType NoteProperty -Name $Hash -Value @($FilterHashTableExclude[$Hash])
        }
    }
    
    if ( $TimeRange ) {
        if ( $TimeRange.count -ne 2 ) {
            throw "Incorrect time range syntax"
        }
        
        $Start = $TimeRange[0] | ConvertTo-GCUnixTime
        $End = $TimeRange[1] | ConvertTo-GCUnixTime
        
        $Body.start_time_filter = $Start
        $Body.end_time_filter = $End
    }

    if ( $PSCmdlet.ShouldProcess($Body, "pwsh-GC-post-request -Raw -Uri $Uri -ApiKey $Key") ) {
        pwsh-GC-post-request -Raw -Uri $Uri -Body $Body -ApiKey $Key
    }
}
