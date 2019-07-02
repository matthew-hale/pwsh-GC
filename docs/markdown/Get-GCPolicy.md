---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# Get-GCPolicy

## SYNOPSIS
Retrieve a policy from the management server.

## SYNTAX

```
Get-GCPolicy [[-Search] <String>] [[-Section] <String[]>] [[-Protocol] <Array>] [[-Port] <Array>]
 [[-SourceLabel] <Object>] [[-DestinationLabel] <Object>] [[-AnySideLabel] <Object>] [[-SourceProcess] <Array>]
 [[-DestinationProcess] <Array>] [[-AnySideProcess] <Array>] [[-SourceAsset] <Object>]
 [[-DestinationAsset] <Object>] [[-AnySideAsset] <Object>] [[-SourceSubnet] <Array>]
 [[-DestinationSubnet] <String>] [[-AnySideSubnet] <String>] [[-Ruleset] <String>] [[-Comments] <String>]
 [-SourceInternet] [-DestinationInternet] [-AnySideInternet] [[-Limit] <Int32>] [[-Offset] <Int32>] [-Raw]
 [[-ApiKey] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Pulls one or more policy from the management server based on the given parameters. Policies can be returned based on any of their criteria, including a generic search string.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AnySideAsset
{{ Fill AnySideAsset Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AnySideInternet
{{ Fill AnySideInternet Description }}

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

### -AnySideLabel
{{ Fill AnySideLabel Description }}

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

### -AnySideProcess
{{ Fill AnySideProcess Description }}

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

### -AnySideSubnet
{{ Fill AnySideSubnet Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
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
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comments
{{ Fill Comments Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationAsset
{{ Fill DestinationAsset Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationInternet
{{ Fill DestinationInternet Description }}

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

### -DestinationLabel
{{ Fill DestinationLabel Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationProcess
{{ Fill DestinationProcess Description }}

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

### -DestinationSubnet
{{ Fill DestinationSubnet Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
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
Position: 18
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
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
{{ Fill Port Description }}

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

### -Protocol
{{ Fill Protocol Description }}

```yaml
Type: Array
Parameter Sets: (All)
Aliases:
Accepted values: TCP, UDP

Required: False
Position: 2
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

### -Ruleset
{{ Fill Ruleset Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
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

### -Section
{{ Fill Section Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: allow, alert, block, override_allow, override_alert, override_block

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceAsset
{{ Fill SourceAsset Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceInternet
{{ Fill SourceInternet Description }}

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

### -SourceLabel
{{ Fill SourceLabel Description }}

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

### -SourceProcess
{{ Fill SourceProcess Description }}

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

### -SourceSubnet
{{ Fill SourceSubnet Description }}

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
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
