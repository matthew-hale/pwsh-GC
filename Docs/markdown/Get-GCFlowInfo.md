---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Get-GCFlowInfo

## SYNOPSIS
Returns a custom object containing basic, useful information from a set of flows.
"Useful information" includes process name, count, source ip, destination ip, etc.
sorted by unique where applicable.

## SYNTAX

```
Get-GCFlowInfo [[-Flows] <Array>] [[-Title] <String>] [<CommonParameters>]
```

## DESCRIPTION
This script is intended to be used with data structures generated by the Get-GCRawFlow api call made to a GuardiCore management server.
It takes an array of flows and creates a custom PowerShell object containing sorted data pulled from the array.

Specifically, the data pulled includes:

-Source Process Name(s)
-Destination Process Name(s)
-Count of flow objects
-Total number of connections (some flows have more than one connection)
-Source IP address(es)
-Destination IP address(es)
-Destination Port(s)

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Flows
\[System.Array\] Net flows, as formatted from GuardiCore (converted from JSON).
Can also be piped in.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Title
\[System.String\] Title of the resultant object.
Defaults to "Flows".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Flows
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. This script takes no pipeline inputs.
## OUTPUTS

### System.Object.PSCustomObject
## NOTES

## RELATED LINKS