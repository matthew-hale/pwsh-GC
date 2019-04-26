---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Get-GCAsset

## SYNOPSIS
Encapsulates the "GET /assets" API call.

## SYNTAX

```
Get-GCAsset [[-Search] <String>] [[-Status] <String>] [[-Risk] <Int32>] [[-Label] <Object>] [[-Asset] <Object>]
 [[-Limit] <Int32>] [[-Offset] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Searches can be based on hostname, domain name, IP, etc.
Note that when seraching, GuardiCore's search may return more assets than the one with the specific string given.
An example of this is a search for "10.0.0.1" returning assets with IPs "10.0.0.12", "10.0.0.100", and "10.0.0.1".
Additional parsing may be required.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Search
\[System.String\] A generic search string.

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

### -Status
\[System.String\] Status of the asset.
Allows: "on","off"

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

### -Risk
\[Int32\] Risk level.
Allows: (0..3)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
\[PSTypeName("GCLabel")\] One or more GCLabel objects.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Asset
{{Fill Asset Description}}

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

### -Limit
\[Int32\] Max number of returned assets.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
\[Int32\] Index of where the query will start returning results.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [System.String] $Search parameter.
## OUTPUTS

### [PSTypeName("GCAsset")] One or more GCAsset objects.
## NOTES

## RELATED LINKS
