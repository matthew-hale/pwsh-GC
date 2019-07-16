---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# Get-GCSavedMap

## SYNOPSIS
Retrieve a saved map from the management server.

## SYNTAX

```
Get-GCSavedMap [[-Search] <String>] [[-State] <String>] [[-Features] <Object>] [[-Asset] <Object>]
 [[-Label] <Object>] [[-TimeRange] <DateTime[]>] [[-AuthorID] <String>] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [-Raw] [[-ApiKey] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Pulls one or more saved maps from the management server based on the given parameters.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GCSavedMap -Search "Test map"
```

Get all saved maps that match the search string "Test map"

## PARAMETERS

### -ApiKey
Provide an external ApiKey, in place of the global GCApiKey variable.

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

### -Asset
Get maps based on the presence of one or more assets in the filter.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthorID
Get maps based on the map's author.

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

### -Features
Get maps based on their included features (time resolution, include processes).

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: include_processes, time_resolution

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
Get maps based on the presence of one or more labels in the filter.

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
Position: 7
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
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Return the raw result instead of the map objects directly.

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

### -Search
Get maps based on a search string.

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

### -State
Get maps based on state (ready, in-progresss, queued, etc.)

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: READY, IN_PROGRESS, QUEUED, CANCELLED, FAILED, EMPTY

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeRange
Get maps based on their set time range.

```yaml
Type: DateTime[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
