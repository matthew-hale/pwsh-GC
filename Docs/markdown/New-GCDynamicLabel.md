---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# New-GCDynamicLabel

## SYNOPSIS
Encapsulates the "POST /visibility/labels" API request.

## SYNTAX

```
New-GCDynamicLabel [[-LabelKey] <String>] [[-LabelValue] <String>] [[-Argument] <String>] [[-Field] <String>]
 [[-Operation] <String>] [[-Criteria] <Array>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -LabelKey
The key of the new label.

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
The value of the new label.

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

### -Argument
The argument of the dynamic label definition (e.g.
"Demo").

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Field
The field of the dynamic label definition; accepts "name","numeric_ip_addresses"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Operation
The operation of the dynamic label definition; accepts "STARTSWITH","ENDSWITH","EQUALS","CONTAINS","SUBNET","WILDCARDS"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Criteria
One or more custom objects similar to the above parameters in structure.
Example:

\[PSCustomObject\]@{
	field = "name"
	op = "STARTSWITH"
	argument = "example"
}

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [PSCustomObject] One or more criteria objects.
## OUTPUTS

### application/json data
## NOTES

## RELATED LINKS
