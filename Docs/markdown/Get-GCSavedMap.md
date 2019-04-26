---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Get-GCSavedMap

## SYNOPSIS
Encapsulates the "GET /visibility/saved-maps" api request

## SYNTAX

```
Get-GCSavedMap [[-Search] <String>] [[-State] <String>] [[-Features] <Object>] [[-Asset] <Object>]
 [[-Label] <Object>] [[-TimeRange] <DateTime[]>] [[-AuthorID] <String>] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Search
A generic search string; use this to search for maps by name.

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

### -State
Current state of the map; accepts "READY","IN_PROGRESS","QUEUED","CANCELLED","FAILED","EMPTY"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Features
Map features; accepts "include_processes","time_resolution"

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

### -Asset
One or more GCAsset objects.

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

### -Label
One or more GCLabel objects.

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

### -TimeRange
Array containing a start and end time, as DateTime objects.

```yaml
Type: DateTime[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthorID
ID of the map author.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
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
Position: 8
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
Position: 9
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. This function accepts no pipeline inputs.
## OUTPUTS

### PSTypeName="GCSavedMap"
## NOTES

## RELATED LINKS
