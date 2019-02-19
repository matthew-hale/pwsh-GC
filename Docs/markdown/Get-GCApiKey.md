---
external help file: GuardiCoreHelper-help.xml
Module Name: GuardiCoreHelper
online version:
schema: 2.0.0
---

# Get-GCApiKey

## SYNOPSIS
Authenticates with the given management server, and stores a key in a global variable called "GCApiKey"

## SYNTAX

```
Get-GCApiKey [-Server] <String> [-Credentials] <PSCredential> [<CommonParameters>]
```

## DESCRIPTION
To make GuardiCore API calls, an API token must be included in the headers.
Thus, this first API call must be made; it returns a token that can be used for further API calls.
The token represents a user session, and has the same timeout duration.
The GCApiKey variable includes this token, plus the Uri of the management server that it's authenticated with.
All functions in the module that use this token are able to get the Uri and the token from this variable without further user input.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Server
\[System.String\] GuardiCore management server, in the format: "cus-5555".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credentials
\[PSCredential\] API user credentials.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [PSCredential] $Credentials parameter.
## OUTPUTS

### None. This function has no pipeline output.
## NOTES

## RELATED LINKS
