
function ReturnEmptyArrayAsArray()
{
    $arr = @()
    return ,$arr # the comma is necessary if we want powershell to return list instead of $null
}

function ReturnEmptyArrayAsNull()
{
    $arr = @()
    return $arr # during the output stream conversion the empty array get converted to $null
}

function ReturnArray()
{
    $arr = @()
    $arr += "Line1"
    $arr += "Line2"
    return $arr
}

$arr = ReturnArray
#$arr = ReturnEmptyArrayAsArray
#$arr = ReturnEmptyArrayAsNull

if( $arr ) # check for emptyness
{
  $numElems = @($arr).Count
  Write-Output "Number of array elements: $numElems"
}

# dump the array
$index = 0
foreach ($elem in $arr) {
	$index += 1
    Write-Output "#$index $elem"
}
