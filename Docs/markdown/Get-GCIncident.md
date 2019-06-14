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

{{ Add example description here }}

## PARAMETERS

### -AnySideAsset
{{ Fill AnySideAsset Description }}

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
{{ Fill AnySideLabel Description }}

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

### -DestinationAsset
{{ Fill DestinationAsset Description }}

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
{{ Fill DestinationLabel Description }}

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
{{ Fill EndTime Description }}

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
{{ Fill ExcludeTag Description }}

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
{{ Fill IncidentType Description }}

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
{{ Fill IncludeTag Description }}

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
{{ Fill Limit Description }}

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

### -Severity
{{ Fill Severity Description }}

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
{{ Fill SourceAsset Description }}

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
{{ Fill SourceLabel Description }}

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
{{ Fill StartTime Description }}

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
