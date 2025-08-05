$stdOutFile = "StdOut.txt"
$process = Start-Process -FilePath "cmd.exe" -ArgumentList "/cdir" -Wait -PassThru -NoNewWindow -RedirectStandardOutput $stdOutFile
$exitCode = $process.ExitCode

Add-Content -Path $stdOutFile -Value "abc|def"

# write the lines from StdOut.txt to the console
$output = Get-Content $stdOutFile
foreach ($line in $output) {
    Write-Host $line
}

if ($exitCode -ne 0) {
    Write-Host "Failed to create new release. Exit code: $exitCode"
    exit $exitCode
}


# get the last line of the output
# the last line contains "oldver|newver"
$lastLine = $output[-1].Trim()
if ($lastLine -notmatch "\|") {
    $oldVersion = ""
    $newVersion = ""
} else {
    $splitVersions = $lastLine.Split("|")
    $oldVersion = $splitVersions[0]
    $newVersion = $splitVersions[1]
}

Write-Host "##vso[task.setvariable variable=oldVersion]$oldVersion"
Write-Host "##vso[task.setvariable variable=newVersion]$newVersion"
