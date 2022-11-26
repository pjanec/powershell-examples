$dir = "$PSScriptRoot"
[string[]]$creds = Get-Content "$dir\creds.txt" -First 2
$usr = $creds[0]
$pwd = $creds[1]
"$usr"
"$pwd"
