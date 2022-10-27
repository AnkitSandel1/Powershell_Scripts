# Circular Procmon
   
Powershell_Script for Circular ProcMon
  
# DESCRIPTION

 The script runs continuously for defined number of counters in a Circular fashion for one minute, this will contineously monitor for a defined event in event viewer logs 
 and stop the traces as soon as the event is occured.
 In order to save space script have mechanism to delete the old files and keeps latest 5 files.  
  
# Prerequisites 

1. Download Process Monitor from -- https://learn.microsoft.com/en-us/sysinternals/downloads/procmon
2. Exctract and save it to desired directory on affected server.
3. Keep the path ready from procmon64.exe so that once we run the script you can provide the path to start tracing.
4. Enter the event ID on the script window when it is popped up.
5. Script will start in loop until it captures the problemetic event.
  
#PowerShell Version Requires -version 3.0
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Function that Captures Process Monitor Traces in Circular fashion.
.Example
    Locate the script on server and execute as guided below, 
    .\CircularProcmon.ps1
#>

