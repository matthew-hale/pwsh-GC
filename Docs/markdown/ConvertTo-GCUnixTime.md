---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# ConvertTo-GCUnixTime

## SYNOPSIS
{{ Converts datetime objects into Unix timestamps in milliseconds. }}

## SYNTAX

```
ConvertTo-GCUnixTime [-DateTime] <DateTime> [<CommonParameters>]
```

## DESCRIPTION
{{ GuardiCore stores timestamps as Unix timestamps in milliseconds. This can be annoying to deal with, so the helper functions ConvertFrom- and ConvertTo-GCUnixTime are used to make the transition seamless. }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ ConvertTo-GCUnixTime -DateTime "1/1/2019 00:00:00" }}
```

{{ Convert a DateTime-formatted string as a named parameter. }}

### Example 2
```powershell
PS C:\> {{ Get-Date | ConvertTo-GCUnixTime }}
```

{{ Convert a DateTime object using the pipeline. }}

## PARAMETERS

### -DateTime
{{ A DateTime object, or a string formatted as such. }}

```yaml
Type: DateTime
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

### System.DateTime

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
