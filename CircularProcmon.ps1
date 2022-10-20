# Powershell_Script for Circular ProcMon

#Requires -version 3.0
#Requires -RunAsAdministrator
# the cluster tracer 2.7
<#
.SYNOPSIS
    Function that Captures Process Monitor Traces in Circular fashion.
.DESCRIPTION
    The script runs contineously for defined number of counters in a Circular fashion for one minute, this will contineously monitor for a defined event in event viewer logs 
    and stop the traces as soon as the event is occured.
    In order to save space script have mechanism to delete the old files and keeps latest 5 files.
.Example
    Locate the script on server and execute as guided below, 
    .\filename.ps1
#>
[ScriptBlock]$CircularProcmon= {
$Path= Read-Host "Enter the path where the Procmon64.exe is located"

$checkpath = Test-Path $path\procmon64.exe
 if ($checkpath -eq $false){
 
 write-host -ForegroundColor Red "Invalid path entered, stopping the script"
 

 break
 
 }


$EventID= Read-Host "Enter the Event ID for the issue"
C:\ProcMon\procmon64.exe /Terminate

$Logcount=2
$Counter =0
 $folderforlogs = "c:\ProcMonLogs"
 
 
# Check for log path is available or not, if present then delete 

 $checkfolder = Test-Path $folderforlogs
 if ($checkfolder -eq $true){
 
 remove-item -LiteralPath $folderforlogs -Recurse
 
 }
 mkdir $folderforlogs
  
do
{
 $Counter = $Counter+1
 $Filename = (Get-Date).ToString("hh-mm-ss")

 
 
 $Filepath="C:\ProcMonlogs\Logfile_"
 $Parameters = "/Backingfile /AcceptEula /Minimized /Quiet" 
 cd $path

 # start the process monitor
 .\procmon64.exe $Parameters $Filepath"$Filename".pml
write-host -ForegroundColor Green "Error not found Starting trace" $Counter

# Logic to capture procmon for 1 minute
$timeout = new-timespan -Minutes 1
$stopwatch = [diagnostics.stopwatch]::StartNew()

# Loop for 1 minute where elapsed time in timeout variable will be compared with stopwatch

while ($stopwatch.elapsed -lt $timeout)
{

# Logic to search for eventID 

$event = Get-EventLog -LogName System -EntryType Error -InstanceId $EventID  -Newest 1
$evt = $event.TimeGenerated
$currenttime = (Get-Date).DateTime

# Time of the latest captured event saved in $evt will be compared with curret time saved in $currenttime

 If ($evt -eq $currenttime )
{
   write-host  -ForegroundColor Red "error $eventid found stopping that traces and saving the files in $folderforlogs"

   # If event found then terminate the process monitor and break the loop

   C:\ProcMon\procmon64.exe /Terminate  
    break 2
}

elseif ($counter -gt 2)
{

     write-host -ForegroundColor Yellow "Removing Old Files"

     # this will remove the old 5 files from folder

     Get-ChildItem –Path  "C:\ProcMonLogs" –Recurse | Where-Object { $_.CreationTime –lt (Get-Date).AddMinutes(-1) } | Remove-Item
 $counter = 1

}


# Stop the process monitor traces after 1 minute and start again unitl the count is 10.
C:\ProcMon\procmon64.exe /Terminate
}

}
while ($Counter -le $Logcount)

 }


Invoke-Command -ScriptBlock $CircularProcmon



