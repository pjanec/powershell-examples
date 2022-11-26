$dir = "D:\TEMP\FAR"
Get-ChildItem $dir -Recurse -File | sort FullName |
ForEach-Object {
    if(($_.FullName -like "*\.git\*") -or ($_.FullName -like "*\.svn\*") )  { return }
#    {
#        Write-Host "ee", $_.FullName
#    }
#    else
#    {
        Write-Host $_.FullName
#    }
}
