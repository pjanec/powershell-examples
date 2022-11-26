$line = Get-Content "$PSScriptRoot\number.txt" -First 1
$number = $line -as [int]
Write-Output "Number read = $number"