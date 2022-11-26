$matchInfo = Select-String -Path "$PSScriptRoot\file1.txt" -Pattern 'commit = (\w*)'
if ($matchInfo -eq $null)
{
    "nothing found"
}
else
{
    "$($matchInfo.Matches.groups[1].Value)"
}
