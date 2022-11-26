$list = [System.Collections.ArrayList]@()
[void]$list.Add("Line1")
[void]$list.Add("Line2")
foreach ($element in $list) {
	"$element"
}
