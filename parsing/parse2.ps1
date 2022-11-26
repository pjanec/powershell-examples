param( [string]$varList )

foreach($line in $varList)
{
    $delimPos = $line.IndexOf("=")
    if( $delimPos -lt 0 ) { continue }
    $name = $line.Substring(0, $delimPos).Trim()
    $value = $line.Substring($delimPos+1)
    "name: '$name'"
    "value: '$value'"
}
