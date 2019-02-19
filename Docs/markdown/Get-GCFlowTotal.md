---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Get-GCFlowTotal

## SYNOPSIS
Returns the total number of connections in a given array of GuardiCore flow objects.

## SYNTAX

```
Get-GCFlowTotal [-Flow] <Array> [<CommonParameters>]
```

## DESCRIPTION
Each flow has a "count" field that increments whenever an identical flow is recorded.
To obtain the true total number of connections for a given set of flow objects, this function sums each individual count field.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Flow
\[System.Array\] GuardiCore flow objects.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [System.Array] $Flow parameter.
## OUTPUTS

### [Int32] Total count.
## NOTES

## RELATED LINKS
