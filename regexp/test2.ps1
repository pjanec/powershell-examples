$s = "1.2.3.4"
$match = select-string "(\d+)\.(\d+)\.(\d+)\.(\d+)" -inputobject $s

"Input: $s"
"NumMatches: $($match.matches.groups.Count)"
"group[0]: $($match.matches.groups[0].value)"
"group[1]: $($match.matches.groups[1].value)"
"group[2]: $($match.matches.groups[2].value)"
"group[3]: $($match.matches.groups[3].value)"
"group[4]: $($match.matches.groups[4].value)"
