Set-Location $PSScriptRoot

param( [string]$varList )

function Parse1
{
    foreach($line in (Get-Content variables.txt))
    {
        $parts = $line.Split('=', 2)
        $name = $parts[0].Trim()
        $value = $parts[1]
        "name: '$name'"
        "value: '$value'"
    }
}

function Parse2
{
    foreach($line in (Get-Content variables.txt))
    {
        $delimPos = $line.IndexOf("=")
        if( $delimPos -lt 0 ) { continue }
        $name = $line.Substring(0, $delimPos).Trim()
        $value = $line.Substring($delimPos+1)
        "name: '$name'"
        "value: '$value'"
    }
}

function Parse3( $varList )
{
    foreach($line in $varList)
    {
        $delimPos = $line.IndexOf("=")
        if( $delimPos -lt 0 ) { continue }
        $name = $line.Substring(0, $delimPos).Trim()
        $value = $line.Substring($delimPos+1)
        "name: '$name'"
        "value: '$value'"
    }
}

Parse2
