# creates a new folder in sandbox folder
$stamp = (Get-Date -f yyyy-MM-dd_HH-mm-ss)
$folder = "$PSScriptRoot\sandbox\$stamp"
New-Item -Path $folder -ItemType "directory" -Force | Out-Null
#New-Item -Path "$folder\aaa.txt" -ItemType "file" -Force  | Out-Null
Set-Content -Path "$folder\aaa.txt" -Value $stamp