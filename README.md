# GuardiCoreHelper
A collection of Powershell Core modules and scripts for GuardiCore Centra administration and management.

## What's Actually Useful?
#### Get-GCAPIKey
This function takes a String as an argument, specifying a GuardiCore management server. It then calls Get-Credential and makes an API authentication request to the server specified using the user-provided credentials. To make GuardiCore API calls, an API key must be included in the headers. Thus, this first API call must be made; it returns a token that can be used for further API calls. The token represents a user session, and has the same timeout duration. I try to use it as little as possible; obviously an API key is required for further API calls, but you really only need to run this once per session (the default user timeout is 24 hours). Try to hold on to the API key in some way—store it in a file, or just make sure you hold on to the variable in your current session.

#### Get-GCAsset
Given a generic search string, this script performs an API call to get all the assets that match the search. Limit of 100 assets returned for now.

#### Set-GCLabel
Updates/sets a GuardiCore label based on given parameters/assets. Only supports static labels right now.

#### Get-GCFlowInfo.ps1
This script takes an array of flows, as formatted from GuardiCore, and returns a custom object containing basic, useful information from a set of flows. "Useful information" includes process name, count, source ip, destination ip, etc. sorted by unique where applicable. Basically metadata for a set of flows. Pipeline isn't working fully yet.

#### Install-GCAgent.ps1
This script installs the GuardiCore agent to a local machine. Not yet fully automatic, as the install script from GuardiCore contains interactive elements, but it's getting there. It at least automates the "browse & download" process.

## What's Technically Usable?
#### ConvertFrom-GCUnixTime
While technically functional, its sister function isn't, so its intended functionality isn't fully realized. You can definitely feed it datetimes though.

#### Get-GCFlowTotal
Useful in some niche circumstances, this function simply returns the total number of connections in a given array of GuardiCore flow objects. Each flow has a "count" field that increments whenever an identical flow is recorded. To obtain the true total number of connections for a given set of flow objects, this function sums each individual count field. Not present in most common workflows, but still fully functional.
