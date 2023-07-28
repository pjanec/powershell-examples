$parentVar = 1
. $PSScriptRoot\exitcode2.ps1 # run in same scope, changes the var to 7, exit code 2
"var: $parentVar" # should be 7
"subscript exited with: $LASTEXITCODE"