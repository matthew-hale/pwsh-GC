# GuardiCoreHelper
A collection of Powershell modules and scripts for GuardiCore Centra administration and management.

## What's Actually Useful?
#### Get-GCAPIKey
This function takes a String as an argument, specifying a GuardiCore management server. It then calls Get-Credential and makes an API authentication request to the server specified using the user-provided credentials. To make GuardiCore API calls, an API key must be included in the headers. Thus, this first API call must be made; it returns a token that can be used for further API calls. The token represents a user session, and has the same timeout duration. I try to use it as little as possible; obviously an API key is required for further API calls, but you really only need to run this once per session (the default user timeout is 24 hours). Try to hold on to the API key in some way—store it in a file, or just make sure you hold on to the variable in your current session.

#### Set-GCHeaders
This one's really simple: it takes the API token returned from Get-GCAPIKey and places it into a "System.Collections.Generic.Dictionary" object to be used as part of a header for Invoke-WebRequest. It has an optional -Post switch that adds "Content-Type: application/json" to headers used in POST requests. (This function is here because I use it all the time; it can take the token from the pipeline, so I can pipe Get-GCAPIKey into this and get my usable header in one line.)

#### Get-GCFlowInfo.ps1
This script takes an array of flows, as formatted from GuardiCore, and returns a custom object containing basic, useful information from a set of flows. "Useful information" includes process name, count, source ip, destination ip, etc. sorted by unique where applicable. Basically metadata for a set of flows. Pipeline isn't working fully yet.

## What's Technically Usable?
#### ConvertFrom-GCUnixTime
While technically functional, its sister function isn't, so its intended functionality isn't fully realized. You can definitely feed it UTC datetimes though.

#### Get-GCFlowTotal
Useful in some niche circumstances, this function simply returns the total number of connections in a given array of GuardiCore flow objects. Each flow has a "count" field that increments whenever an identical flow is recorded. To obtain the true total number of connections for a given set of flow objects, this function sums each individual count field. Not present in most common workflows, but still fully functional.
