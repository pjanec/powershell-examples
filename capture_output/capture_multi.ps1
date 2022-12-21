$allLines = @(dir)
"num lines: $($allLines.Count)"
"lines:"
foreach( $line in $allLines )
{
  "$line"
}
