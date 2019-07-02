---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# Get-GCIncident

## SYNOPSIS
Retrieve an incident from the management server.

## SYNTAX

```
Get-GCIncident [[-StartTime] <DateTime>] [[-EndTime] <DateTime>] [[-Severity] <String[]>]
 [[-IncidentType] <Object>] [[-SourceAsset] <String>] [[-DestinationAsset] <String>] [[-AnySideAsset] <String>]
 [[-SourceLabel] <Object>] [[-DestinationLabel] <Object>] [[-AnySideLabel] <Object>] [[-IncludeTag] <Array>]
 [[-ExcludeTag] <Array>] [[-Limit] <Object>] [[-Offset] <Int32>] [-Raw] [[-ApiKey] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Pulls one or more agents from the management server based on the given parameters. Agents can be returned based on agent version, kernel version, string search, etc.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GCIncident
```

Get incidents using default parameters.

### Example 2
```powershell
PS C:\> Get-GCIncident -IncludeTag "Policy Violation"
```

Get all incidents with the "Policy Violation" tag.

## PARAMETERS

### -AnySideAsset
Get incidents by asset on either side.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AnySideLabel
Get incidents by label on either side.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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

### -DestinationAsset
Get incidents by asset in the destination.

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

### -DestinationLabel
Get incidents by label in the destination.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndTime
The end of the time window.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeTag
Get incidents that do not have tags that match this parameter.

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

### -IncidentType
Get incidents by type.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: Incident, Deception, Network Scan, Reveal, Experimental

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeTag
Get incidents that have tags that match this parameter.

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

### -Limit
The maximum number of objects to return.

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
Return the raw result instead of the incident objects directly.

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

### -Severity
Get incidents by severity.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Low, Medium, High

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceAsset
Get incidents by asset in the source.

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

### -SourceLabel
Get incidents by label in the source.

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

### -StartTime
The beginning of the time window.

```yaml
Type: DateTime
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
