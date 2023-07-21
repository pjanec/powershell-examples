$line = "Hello world!"

$result =  $line | Select-String -Pattern "(\w+) (\w+)"

if( $result.Matches.Length -gt 0 )
{
  "Match!"
}
else
{
  "No match..."
}

$result |
    Foreach-Object {
        $first, $second = $_.Matches[0].Groups[1..2].Value   # this is a common way of getting the groups of a call to select-string
        [PSCustomObject] @{
            FirstWord = $first
            SecondWord = $second
        }
    }

