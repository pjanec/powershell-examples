& "$PSScriptRoot\t1.ps1"
$t1ExitCode = $LASTEXITCODE
"t1ExitCode: $t1ExitCode"

& "$PSScriptRoot\t2.ps1"
$t2ExitCode = $LASTEXITCODE
"t2ExitCode: $t2ExitCode"
