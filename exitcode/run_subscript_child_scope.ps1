$parentVar = 1
& $PSScriptRoot\exitcode2.ps1  # run in child scope, parentVar not affected, exit code 2
"var: $parentVar" # should be 1
"subscript exited with: $LASTEXITCODE"