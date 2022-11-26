Set-Location "$PSScriptRoot"
& "$PSScriptRoot\batch1.bat" -n 1 -w 127.0.0.1
Write-Output $LASTEXITCODE
