---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Get-GCAgent

## SYNOPSIS
Encapsulates the "GET /agents" API call.

## SYNTAX

```
Get-GCAgent [[-Version] <Array>] [[-Kernel] <Array>] [[-OS] <Array>] [[-Label] <Object>] [[-Status] <Array>]
 [[-Flag] <Int32>] [[-Enforcement] <Array>] [[-Deception] <Array>] [[-Detection] <Array>] [[-Reveal] <Array>]
 [[-Activity] <Array>] [[-GCFilter] <String>] [[-Limit] <Int32>] [[-Offset] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets one or more agents based on the given parameters/filters.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Version
\[System.String\] Version of the agent

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Kernel
\[System.String\] Version of the kernel

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OS
\[System.String\] General type of OS.
Allows: "Unknown","Windows","Linux"

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
\[PSTypeName("GCLabel")\] One or more GCLabel objects, as returned from Get-GCLabel

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

### -Status
\[System.String\] Status of the agent.
Allows: "Online","Offline"

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Flag
= display_status

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enforcement
\[System.String\] Status of the enforcement module.
Allows: "Active","Not Deployed","Disabled"

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Deception
\[System.String\] Status of the deception module.
Allows: "Active","Not Deployed"

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Detection
\[System.String\] Status of the detection module.
Allows: "Active","Not Deployed"

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reveal
\[System.String\] Status of the reveal module.
Allows: "Active","Not Deployed"

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Activity
\[System.String\] Time period of when the agent was last active.
Allows: "last_month","last_week","last_12_hours","last_24_hours","not_active"

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GCFilter
\[System.String\] Filter of Agent ID/Agent Hostname/IP Address.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
\[Int32\] Max number of returned agents.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
\[Int32\] Index of where the query will start returning results.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. This function takes no pipeline input.
## OUTPUTS

### [PSTypeName("GCAgent")] One or more GCAgent objects.
## NOTES

## RELATED LINKS
