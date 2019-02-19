---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Get-GCLabel

## SYNOPSIS
Encapsulates the "GET /visibility/labels" API call.

## SYNTAX

```
Get-GCLabel [-FindMatches] [[-LabelKey] <String>] [[-LabelValue] <String>] [[-Limit] <Int32>]
 [[-Offset] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves labels that fit the parameters given.
Additionally includes member assets if find_matches is set.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -FindMatches
Switch - if set to true, request returns the assets that match the label's definition.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LabelKey
The key of the label.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LabelValue
The value of the label.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum number of labels to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
The index of the first result to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. This function accepts no pipeline inputs.
## OUTPUTS

### [PSTypeName="GCLabel"] One or more GCLabel objects.
## NOTES

## RELATED LINKS
