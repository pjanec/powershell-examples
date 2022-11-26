# relative path using same directory as where this script is located
$thisScriptPath = $MyInvocation.MyCommand.Path
Write-output $thisScriptPath
"ThisPath: $thisScriptPath"
$thisScriptDir = Split-Path $thisScriptPath
"ThisDir: $thisScriptDir"
$newScriptPath = Join-Path $thisScriptDir "t1.ps1"
"Starting: $newScriptPath"
. $newScriptPath
$result=myfunc1
"$result"
