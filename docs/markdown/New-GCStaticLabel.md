---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# New-GCStaticLabel

## SYNOPSIS
Create a new label defined with manually added assets on the management server.

## SYNTAX

```
New-GCStaticLabel [[-Asset] <Object>] [-LabelKey] <String> [-LabelValue] <String> [[-ApiKey] <Object>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a new label defined with one or more manually added assets on the management server. Assets are defined as asset objects, as returned by the GuardiCore API.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-GCStaticLabel -Asset (Get-GCAsset -Search "demo") -LabelKey Test -LabelValue Example
```

Create a label at Test: Example containing all assets that match the search string "demo".

## PARAMETERS

### -ApiKey
Provide an external ApiKey, in place of the global GCApiKey variable.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Asset
One or more assets to manually add to the label.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LabelKey
The key for the new label.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LabelValue
The value for the new label.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
