---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Get-GCPolicy

## SYNOPSIS
Encapsulates the "GET /visibility/policy/sections/{section_name}/rules" API call

## SYNTAX

```
Get-GCPolicy [[-Search] <String>] [[-Protocol] <Array>] [[-Action] <String>] [[-Port] <Array>]
 [[-SourceLabel] <Object>] [[-DestinationLabel] <Object>] [[-AnySideLabel] <Object>] [[-SourceProcess] <Array>]
 [[-DestinationProcess] <Array>] [[-AnySideProcess] <Array>] [[-SourceAsset] <Object>]
 [[-DestinationAsset] <Object>] [[-AnySideAsset] <Object>] [[-SourceSubnet] <Array>]
 [[-DestinationSubnet] <String>] [[-AnySideSubnet] <String>] [[-Ruleset] <String>] [[-Comments] <String>]
 [-SourceInternet] [-DestinationInternet] [-AnySideInternet] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns one or more policy objects based on given parameters.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Search
Generic search string; searches comments, rulesets, sources & destinations.

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

### -Protocol
Accepts TCP and/or UDP.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @("TCP","UDP")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Action
The section that the policy resides; accepts allow, alert, block, override.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Allow
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
One or more ports that are included in the policy.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceLabel
One or more GCLabel objects in the source of the policy.

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

### -DestinationLabel
One or more GCLabel objects in the destination of the policy.

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

### -AnySideLabel
One or more GCLabel objects in the source or the destination of the policy.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceProcess
One or more processes in the source of the policy.

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

### -DestinationProcess
One or more processes in the destination of the policy.

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

### -AnySideProcess
One or more processes in the source or the destination of the policy.

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

### -SourceAsset
One or more GCAsset objects in the source of the policy.

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

### -DestinationAsset
One or more GCAsset objects in the destination of the policy.

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

### -AnySideAsset
One or more GCAsset objects in the source or the destination of the policy.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceSubnet
One or more subnets in the source of the policy.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationSubnet
One or more subnets in the destination of the policy.

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

### -AnySideSubnet
One or more subnets in the source or the destination of the policy.

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

### -Ruleset
The ruleset that the policy belongs to.

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

### -Comments
The comments in the policy.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceInternet
Switch - if the source is an internet address.

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

### -DestinationInternet
Switch - if the destination is an internet address.

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

### -AnySideInternet
Switch - if the source or the destination is an internet address.

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

### -Limit
The maximum number of results to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
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
Position: 20
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

### [PSTypeName="GCPolicy"] One or more GCPolicy objects.
## NOTES

## RELATED LINKS
