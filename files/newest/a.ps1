# runs script "b.ps1" 5 times (each creating a new folder)
# copies the content of the directory created during the first pass into a 'reference' directory

$path = "$PSScriptRoot\sandbox"

# delete the reference folder


$refPath = "$path\reference"
if( Test-Path $refPath -PathType Container )
{
    "Removing reference '$refPath'"
    Remove-Item -Recurse -Force $refPath
}


# remeber what folder was the newest one
$newestBeforeTest = Get-ChildItem -Path $path | where { $_.PsIsContainer} | sort LastWriteTime | select -last 1
"newestBeforeTest: $newestBeforeTest"

# run the test with evaluation
#Start-Process cmd.exe "/c runTest.bat" -NoNewWindow -Wait
"test pass: 1"
& "$PSScriptRoot\b.ps1"

# there should be new folder existing now, created by the evaluation - find it
$newestAfterTest = Get-ChildItem -Path $path | where { $_.PsIsContainer} | sort LastWriteTime | select -last 1
"newestAfterTest: $newestAfterTest"

# make it the reference one
if( $newestAfterTest ) {
    "Copying '$($newestAfterTest.Name)' as reference"
    Copy-Item -Path $newestAfterTest -Destination $refPath -recurse -Force
}

# run the test multiple times
For ($i=2; $i -le 5; $i++) {
  "test pass: $i"
  & "$PSScriptRoot\b.ps1"
  Start-Sleep -Seconds 1
}