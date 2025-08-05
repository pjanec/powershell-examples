$url = "https://server/blabla"
$pat = "your_pat_here"
# insert a content of the $pat variable right after the "https://" in the $url
# - find the first occurence of "https://"
# - insert the content of the $pat variable right after it
# - print the result
$pat = $pat -replace ":", "%3A"
$url = $url -replace "https://", "https://:$pat@"
Write-Host $url


