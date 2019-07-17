---
external help file: pwsh-GC-help.xml
Module Name: pwsh-GC
online version:
schema: 2.0.0
---

# Get-GCAsset

## SYNOPSIS
Retrieve an asset from the management server.

## SYNTAX

```
Get-GCAsset [[-Search] <String>] [[-Status] <String>] [[-Risk] <String[]>] [[-Label] <Object>]
 [[-Asset] <Object>] [[-Limit] <Int32>] [[-Offset] <Int32>] [-Raw] [[-ApiKey] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Pulls one or more assets from the management server based on the given parameters. Assets can be returned based on hostname, label, risk level, etc.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GCAsset -Search Demo-Hostname
```

Retrieve all assets that match the "Demo-Hostname" search string.

## PARAMETERS

### -ApiKey
Provide an external ApiKey, in place of the global GCApiKey variable.

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

### -Asset
Get assets based on one or more GuardiCore asset objects.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Assets, ID

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
Get assets based on one or more GuardiCore label objects.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Limit
The maximum number of objects to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Return the raw result instead of the asset objects directly.

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

### -Risk
Get assets based on their risk level.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: 0, 1, 2, 3

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Search
Get assets based on a search string.

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

### -Status
Get assets based on their status.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: on, off

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
