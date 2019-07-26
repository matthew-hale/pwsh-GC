---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# New-GCDynamicLabel

## SYNOPSIS
Create a new label with given dynamic criteria on the management server.

## SYNTAX

```
New-GCDynamicLabel [[-LabelKey] <String>] [[-LabelValue] <String>] [[-Argument] <String>] [[-Field] <String>]
 [[-Operation] <String>] [[-Criteria] <Array>] [-Raw] [[-ApiKey] <Object>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Create a new label with the given dynamic criteria. Labels can have as many dynamic criteria as provided.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-GCDynamicLabel -LabelKey Test -LabelValue Example -Argument demo -Field name -Operation STARTSWITH
```

Create a new label at Test: Example with one dynamic criteria: Name starts with "demo".

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

### -Argument
The value in the criteria that the asset must match (e.g. "falcon" for a name match).

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

### -Criteria
One or more custom objects containing operation, argument, and field.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Field

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: name, numeric_ip_addresses, id

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LabelKey
The key of the label to be created.

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

### -LabelValue
The value of the label to be created.

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

### -Operation
The type of comparison to make (e.g. startswith, endswith, contains).

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: STARTSWITH, ENDSWITH, EQUALS, CONTAINS, SUBNET, WILDCARDS

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Return the raw result of the post request.

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

### System.Array

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
