---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# Get-GCRawFlow

## SYNOPSIS
Retrieve an unaggregated flow from the management server.

## SYNTAX

```
Get-GCRawFlow [[-StartTime] <DateTime>] [[-EndTime] <DateTime>] [[-SourceProcess] <Array>]
 [[-DestinationProcess] <Array>] [[-AnySideProcess] <Array>] [[-SourceAsset] <Array>]
 [[-DestinationAsset] <Array>] [[-AnySideAsset] <Array>] [[-SourceLabel] <Array>] [[-DestinationLabel] <Array>]
 [[-AnySideLabel] <Array>] [-SourceInternet] [-DestinationInternet] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [-Raw] [[-ApiKey] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Pulls one or more raw flow objects from the management server based on given parameters.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GCRawFlow
```

Get raw flows using default parameters.

### Example 2
```powershell
PS C:\> Get-GCRawFlow -DestinationProcess nginx -SourceProcess chrome.exe -StartTime "1/1/2000" -EndTime "2/1/2000" -Limit 5000
```

Get up to 5000 raw flows that occurred between 1/1/2000 and 2/1/2000, where the source process is chrome.exe and the destination process is nginx.

## PARAMETERS

### -AnySideAsset
Get flows based on the presence of one or more assets in either the source or the destination.

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

### -AnySideLabel
Get flows based on the presence of one or more labels in either the source or the destination.

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

### -AnySideProcess
Get flows based on the presence of one or more processes in either the source or the destination.

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

### -ApiKey
Provide an external ApiKey, in place of the global GCApiKey variable.

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

### -DestinationAsset
Get flows based on the presence of one or more assets in the destination.

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

### -DestinationInternet
Get flows based on the destination address being either internal or external.

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
Get flows based on the presence of one or more labels in the destination.

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

### -DestinationProcess
Get flows based on the presence of one or more processes in the destination.

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

### -EndTime
Get flows that occurred before this time.

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

### -Limit
The maximum number of objects to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Return the raw result instead of the flow objects directly.

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

### -SourceAsset
Get flows based on the presence of one or more assets in the source.

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

### -SourceInternet
Get flows based on the source address being either internal or external.

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
Get flows based on the presence of one or more labels in the source.

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

### -SourceProcess
Get flows based on the presence of one or more processes in the destination.

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

### -StartTime
Get flows that occurred after this time.

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
