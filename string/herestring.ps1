# note: no new line is added to the string at the end
$a = @"
this is a string
"@

# note: new lines added only in the middle
$b = @"
this is a
three lines
string
"@

$ab = $a + $b

Write-Output $ab
