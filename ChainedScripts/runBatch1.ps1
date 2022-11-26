Set-Location "$PSScriptRoot"
$process = start-process batch1.bat -ArgumentList "-n 1 -w 127.0.0.1" -PassThru -Wait -NoNewWindow
$process.ExitCode
