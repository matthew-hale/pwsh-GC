---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# Get-GCAgent

## SYNOPSIS
Retrieve an agent from the management server.

## SYNTAX

```
Get-GCAgent [[-Search] <String>] [[-Version] <String[]>] [[-Kernel] <String[]>] [[-OS] <String[]>]
 [[-Label] <Object>] [[-Status] <String[]>] [[-Flag] <Object>] [[-Enforcement] <String[]>]
 [[-Deception] <String[]>] [[-Detection] <String[]>] [[-Reveal] <String[]>] [[-Activity] <String[]>]
 [[-Limit] <Int32>] [[-Offset] <Int32>] [-Raw] [[-ApiKey] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Pulls one or more agents from the management server based on the given parameters. Agents can be returned based on agent version, kernel version, string search, etc.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GCAgent -Search Demo-Hostname
```

Retrieve all agents that match the "Demo-Hostname" search string.

## PARAMETERS

### -Activity
Get agents based on when their last activity was.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: last_month, last_week, last_12_hours, last_24_hours, not_active

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
Provide an external ApiKey, in place of the global GCApiKey variable.

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
Get agents based on whether the deception module is present.

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

### -Detection
Get agents based on whether the detection module is present.

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

### -Enforcement
Get agents based on whether the enforcement module is present.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Active, Not Deployed, Disabled

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Flag
Get agents based on their status flags.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: undefined, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Kernel
Get agents based on kernel version

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
Get assets based on one or more GuardiCore label objects.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OS
Get agents based on the OS of the machine.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Unknown, Windows, Linux

Required: False
Position: 3
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
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Return the raw result instead of the agent objects directly.

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
Get agents based on whether the reveal module is present.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Active, Not Deployed

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Search
Get agents based on a search string.

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

### -Status
Get agents based on their status.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Online, Offline

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Get agents based on the agent version.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
