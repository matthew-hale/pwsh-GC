---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# New-GCStaticLabel

## SYNOPSIS
Encapsulates the "POST /assets/labels/{key}/{value}" API call.

## SYNTAX

```
New-GCStaticLabel [[-Asset] <PSObject>] [-LabelKey] <String> [-LabelValue] <String> [<CommonParameters>]
```

## DESCRIPTION
Creates a static label with given VMs, specified by unique ID.
if the given Key/Value pair already exists, the new VMs are appended to the existing label.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Asset
\[PSTypeName("GCAsset")\] One or more GuardiCore asset objects.
Used for static label definitions.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -LabelKey
\[System.String\] Key of the label to be updated.
Required for both dynamic and static labels.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LabelValue
\[System.String\] Value of the label to be updated.
Required for both dynamic and static labels.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [PSTypeName("GCAsset")] $Asset parameter; one or more GCAsset objects, as returned by Get-GCAsset.
## OUTPUTS

### [PSCustomObject] application/json data returned from the API request
## NOTES

## RELATED LINKS
