---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# ConvertFrom-GCUnixTime

## SYNOPSIS
Converts a given Unix timestamp in milliseconds to a System.DateTime object in local time.

## SYNTAX

```
ConvertFrom-GCUnixTime [-UnixDate] <Int64> [<CommonParameters>]
```

## DESCRIPTION
GuardiCore uses Unix time in milliseconds for most timestamps in the API.
This funciton, and its sister function ConvertTo-GCUnixTime, allow conversion to/from timestamps (System.DateTime objects) and Unix timestamps (in milliseconds).

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ $Object = Get-GCRawFlow -Limit 1 }}
PS C:\> {{ $Object.slot_start_time }}
1550581069000
PS C:\> {{ $Object.slot_start_time | ConvertFrom-GCUnixTime }}

Tuesday, February 19, 2019 7:57:49 AM


PS C:\>
```

{{ Take a timestamp from an API object and convert it to a datetime object. }}

## PARAMETERS

### -UnixDate
\[Long\] Unix timestamp in milliseconds.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [Int64] $UnixDate parameter.
## OUTPUTS

### [DateTime]
## NOTES
Many functions in this module use objects gathered from the API as inputs. As such, these objects may have timestamps in Unix-based format. Additionally, other functions in the module accept DateTime objects as inputs. This function (and its sister function, ConvertTo-GCUnixTime) is used internally by these functions whenever timestamp conversion is required. Thus, no inputs need to be altered from the user's perspective: DateTime parameters are taken as human dates, and API object timestamps do not need to be altered before they are passed along the pipeline.

## RELATED LINKS
