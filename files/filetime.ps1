$f1 = "$PSScriptRoot\filelist1.txt"
$f2 = "$PSScriptRoot\filelist2.txt"

$f1t = (Get-Item $f1).LastWriteTime
$f2t = (Get-Item $f2).LastWriteTime

"f1t = $f1t"
"f2t = $f2t"


if( $f1t -lt $f2t )
{
   "$f1 is older than $f2"
}
else
{
   "$f1 is younger than $f2"
}

