Write-Host "sub/test1.tmpl.ps1: $DM";
$dir = $MyInvocation.MyCommand.Path
Write-Host "invoked script: $dir"
Write-Host "working dir: $pwd"

$scriptDir = Split-Path $MyInvocation.MyCommand.Path
Write-Host "switching pwd to script's invokation dir: $scriptDir"
Push-Location $scriptDir
Write-Host "working dir: $pwd"
Write-Host "switching pwd back to previous value"
Pop-Location
Write-Host "working dir: $pwd"
