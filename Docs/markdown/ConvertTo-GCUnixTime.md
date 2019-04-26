---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# ConvertTo-GCUnixTime

## SYNOPSIS
Converts a given System.DateTime object to a Unix timestamp in milliseconds.

## SYNTAX

```
ConvertTo-GCUnixTime [-DateTime] <DateTime> [<CommonParameters>]
```

## DESCRIPTION
GuardiCore uses Unix time in milliseconds for most timestamps in the API.
This funciton, and its sister function ConvertFrom-GCUnixTime, allow conversion to/from timestamps (System.DateTime objects) and Unix timestamps (in milliseconds).

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ $Time = "2/19/2019 00:00:00" }}
PS C:\> {{ $Time | ConvertTo-GCUnixTime }}
1550552400000
PS C:\>
```

{{ Convert a specific date/time to a timestamp for use in a custom API request Uri. }}

## PARAMETERS

### -DateTime
\[DateTime\] The timestamp you wish to convert to Unix time in milliseconds.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [DateTime] $DateTime parameter.
## OUTPUTS

### [Int64] Unix timestamp in milliseconds.
## NOTES
Many functions in this module use objects gathered from the API as inputs. As such, these objects may have timestamps in Unix-based format. Additionally, other functions in the module accept DateTime objects as inputs. This function (and its sister function, ConvertFrom-GCUnixTime) is used internally by these functions whenever timestamp conversion is required. Thus, no inputs need to be altered from the user's perspective: DateTime parameters are taken as human dates, and API object timestamps do not need to be altered before they are passed along the pipeline.

## RELATED LINKS
