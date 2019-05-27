---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# Get-GCAgent

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Get-GCAgent [[-Version] <String[]>] [[-Kernel] <String[]>] [[-OS] <String[]>] [[-Label] <Object>]
 [[-Status] <String[]>] [[-Flag] <Object>] [[-Enforcement] <String[]>] [[-Deception] <String[]>]
 [[-Detection] <String[]>] [[-Reveal] <String[]>] [[-Activity] <String[]>] [[-Search] <String>]
 [[-Limit] <Int32>] [[-Offset] <Int32>] [-Raw] [[-ApiKey] <Object>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Activity
{{ Fill Activity Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: last_month, last_week, last_12_hours, last_24_hours, not_active

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
{{ Fill ApiKey Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Deception
{{ Fill Deception Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Active, Not Deployed

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Detection
{{ Fill Detection Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Active, Not Deployed

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enforcement
{{ Fill Enforcement Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Active, Not Deployed, Disabled

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Flag
{{ Fill Flag Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: undefined, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Kernel
{{ Fill Kernel Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
{{ Fill Label Description }}

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

### -Limit
{{ Fill Limit Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OS
{{ Fill OS Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Unknown, Windows, Linux

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
{{ Fill Offset Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
{{ Fill Raw Description }}

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

### -Reveal
{{ Fill Reveal Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Active, Not Deployed

Required: False
Position: 9
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
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
{{ Fill Status Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Online, Offline

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
{{ Fill Version Description }}

```yaml
Type: String[]
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
