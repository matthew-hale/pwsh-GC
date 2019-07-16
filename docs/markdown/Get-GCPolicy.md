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
Pulls one or more policies from the management server based on the given parameters. Policies can be returned based on any of their criteria, including a generic search string.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GCPolicy
```

Get policies using default parameters.

### Example 2
```powershell
PS C:\> Get-GCPolicy -Limit 5 -SourceInternet
```

Get up to 5 policies that define source as an Internet address.

## PARAMETERS

### -AnySideAsset
Get policies based on the presence of one or more assets in either the source or the destination.

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
Get policies that define either the source or the destination as being either an internet or private address.

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
Get policies based on the presence of one or more labels in either the source or the destination.

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
Get policies based on the presence of one or more processes in either the source or the destination.

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
Get policies based on the presence of one or more subnets in either the source or the destination.

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
Provide an external ApiKey, in place of the global GCApiKey variable.

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
Get policies based on their comments.

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
Get policies based on the presence of one or more assets in the destination.

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
Get policies that define the destinatino as being either an internet or private address.

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
Get policies based on the presence of one or more labels in the destination.

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
Get policies based on the presence of one or more processes in the destination.

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
Get policies based on the presence of one or more subnets in the destination.

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
The maximum number of objects to return.

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
The index of the first result to be returned.

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
Get policies based on the presence of one or more destination ports.

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
Get policies based on the presence of TCP/UCP in the port protocol.

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
Return the raw result instead of the policy objects directly.

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
Get policies based on their ruleset.

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
Get policies based on a search string.

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
Get policies based on one or more policy sections.

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
Get policies based on the presence of one or more assets in the source.

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
Get policies that define the source as being either an internet or private address.

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
Get policies based on the presence of one or more labels in the source.

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
Get policies based on the presence of one or more processes in the source.

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
Get policies based on the presence of one or more subnets in the destination.

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
