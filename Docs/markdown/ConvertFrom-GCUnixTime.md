---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# ConvertFrom-GCUnixTime

## SYNOPSIS
Converts Unix timestamps from GuardiCore to datetime objects.

## SYNTAX

```
ConvertFrom-GCUnixTime [-UnixDate] <Int64> [<CommonParameters>]
```

## DESCRIPTION
GuardiCore stores timestamps as Unix timestamps in milliseconds. This can be annoying to deal with, so the helper functions ConvertFrom- and ConvertTo-GCUnixTime are used to make the transition seamless.

## EXAMPLES

### Example 1
```powershell
PS C:\> ConvertFrom-GCUnixTime 1550000000000
```

Convert a Unix timestamp as a positional parameter.

### Example 2
```powershell
PS C:\> ConvertFrom-GCUnixTime -UnixDate 1550000000000
```

Convert a Unix timestamp as a named parameter.

### Example 3
```powershell
PS C:\> 1550000000000 | ConvertFrom-GCUnixTime
```

Use the pipeline to convert a Unix timestamp.

## PARAMETERS

### -UnixDate
A Unix timestamp in milliseconds.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int64

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
