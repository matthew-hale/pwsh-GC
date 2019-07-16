---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# New-GCPolicy

## SYNOPSIS
Create a segmentation policy on the management server.

## SYNTAX

```
New-GCPolicy [-Section] <String> [-Action] <String> [[-Protocol] <Array>] [[-Port] <Array>]
 [[-PortRange] <Array>] [[-SourceLabel] <Array>] [[-DestinationLabel] <Array>] [[-SourceLabelFile] <String[]>]
 [[-DestinationLabelFile] <String[]>] [[-SourceProcesses] <Array>] [[-DestinationProcesses] <Array>]
 [[-SourceAsset] <Array>] [[-DestinationAsset] <Array>] [[-SourceSubnet] <String[]>]
 [[-DestinationSubnet] <String[]>] [[-Ruleset] <String>] [[-Comments] <String>] [-SourceInternet]
 [-DestinationInternet] [[-ApiKey] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a segmentation policy based on the given parameters on the management server. Policies can be based on label, asset, process, port, protocol, etc.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-GCPolicy -Section allow -Action allow -SourceInternet -DestinationAsset (Get-GCAsset "dc1") -Ruleset "Example" -Comments "Example allow policy"
```

Create an allow policy for internet traffic going to the "dc1" asset on any port, to any process.

## PARAMETERS

### -Action
The action that the policy should take. For block rules, this can be either Block or Block and Alert.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: allow, alert, block, block_and_alert

Required: True
Position: 1
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
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comments
The comments field in the policy. Takes an arbitrary string.

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

### -DestinationAsset
One or more assets in the destination (multiple assets create an "or" relationship).

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationInternet
The type of destination address; if true, the destination is an internet address. If false, the destination is a private address.

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
The label(s) in the destination. Takes a 2-dimensional array of labels. Inner groups represent an "and" relationship, while the outer group is an "or" relationship.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationLabelFile
Specify destination labels from a file.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationProcesses
The process(es) in the destination. Multiple processes represent an "or" relationship.

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

### -DestinationSubnet
The subnet(s) in the destination. Multiple subnets represent an "or" relationship.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The port(s) in the destination. Multiple ports represent an "or" relationship.

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

### -PortRange
The port range(s) in the destination. Takes one or more arrays containing 2 integer values, representing the start and the end of each range. Multiple port ranges represent an "or" relationship.

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

### -Protocol
The IP protocol(s). If both TCP and UDP are provided, the policy will match either protocol for all given ports.

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

### -Ruleset
The name of the ruleset. Alert/block rules will add this ruleset as a tag on any generated incidents.

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

### -Section
The section that this policy belongs.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: allow, alert, block, override_allow, override_alert, override_block

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceAsset
One or more assets in the source (multiple assets create an "or" relationship).

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

### -SourceInternet
The type of source address; if true, the destination is an internet address. If false, the destination is a private address.

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
The label(s) in the source. Takes a 2-dimensional array of labels. Inner groups represent an "and" relationship, while the outer group is an "or" relationship.

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

### -SourceLabelFile
Specify source labels from a file.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceProcesses
The process(es) in the source. Multiple processes represent an "or" relationship.

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

### -SourceSubnet
The subnet(s) in the source. Multiple subnets represent an "or" relationship.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
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

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
