$arr = ConvertFrom-Json -InputObject "[{""a"":1},{""b"":2}]"
$index = 0; foreach ($elem in $arr) { $index += 1; Write-Output "#$index $elem" }