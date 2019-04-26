---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Set-GCPolicy

## SYNOPSIS
{{Encapsulates the "PUT /visibility/policy/rules/{ruleID}" API request. }}

## SYNTAX

```
Set-GCPolicy [[-Policy] <Object>] [<CommonParameters>]
```

## DESCRIPTION
{{This function takes one or more GCPolicy objects and, by ID, sets the policy on the management server to match them. This is typically used at the end of a pipeline where policy has been fetched from the management server, then altered.}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Policy
{{PSTypeName("GCPolicy") One or more GCPolicy objects, as returned from the API.}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
