---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# Get-GCLabel

## SYNOPSIS
Retrieve a label from the management server.

## SYNTAX

```
Get-GCLabel [[-Search] <String>] [[-LabelKey] <String>] [[-LabelValue] <String>] [-FindMatches]
 [[-DynamicCriteriaLimit] <Int32>] [[-Limit] <Int32>] [[-Offset] <Int32>] [-Raw] [[-ApiKey] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Pulls one or more labels from the management server based on the given parameters. Labels can be returned based on label key and value.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GCLabel -LabelKey Test -LabelValue Value
```

Retrieve the label with a key of "Test" and a value of "Value".

### Example 2
```powershell
PS C:\> Get-GCLabel -LabelKey Test
```

Retrieve all labels with the "Test" key.

### Example 3
```powershell
PS C:\> Get-GCLabel -LabelKey Test -LabelValue Value -FindMatches
```

Retrieve the Test: Value label, and include the matching assets.

## PARAMETERS

### -ApiKey
Provide an external ApiKey, in place of the global GCApiKey variable.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DynamicCriteriaLimit
{{ Fill DynamicCriteriaLimit Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FindMatches
Return additional label data, including all matching assets.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LabelKey
Get labels based on key.

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
Get labels based on value.

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
The maximum number of objects to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
The index of the first result to be returned.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Return the raw result instead of the label objects directly.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Search
{{ Fill Search Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
