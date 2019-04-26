---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Get-GCIncident

## SYNOPSIS
Encapsulates the GET /incidents API request.

## SYNTAX

```
Get-GCIncident [[-StartTime] <DateTime>] [[-EndTime] <DateTime>] [[-Severity] <String[]>]
 [[-IncidentGroup] <Object>] [[-IncidentType] <Object>] [[-SourceAsset] <Object>]
 [[-DestinationAsset] <Object>] [[-AnySideAsset] <Object>] [[-SourceLabel] <Object>]
 [[-DestinationLabel] <Object>] [[-AnySideLabel] <Object>] [[-IncludeTag] <Array>] [[-ExcludeTag] <Array>]
 [[-Limit] <Object>] [[-Offset] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Requests incidents that are generated on a management server, filtered by given parameters.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -StartTime
The start of the time range.

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

### -EndTime
The end of the time range.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Severity
The severity of the incident; accepts "Low","Medium","High"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncidentGroup
{{Fill IncidentGroup Description}}

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

### -IncidentType
{{Fill IncidentType Description}}

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

### -SourceAsset
One or more GCAsset objects in the source of the policy.

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

### -DestinationAsset
One or more GCAsset objects in the destination of the policy.

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

### -AnySideAsset
One or more GCAsset objects in the source or the destination of the policy.

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

### -SourceLabel
One or more GCLabel objects in the source of the policy.

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

### -DestinationLabel
One or more GCLabel objects in the destination of the policy.

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

### -AnySideLabel
One or more GCLabel objects in the source or the destination of the policy.

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

### -IncludeTag
One or more tags to include in the request.

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

### -ExcludeTag
One or more tags to exclude in the request.

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

### -Limit
The maximum number of results to return.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: 20
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
Position: 15
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. This function accepts no pipeline input.
## OUTPUTS

### PSTypeName="GCIncident"
## NOTES

## RELATED LINKS
