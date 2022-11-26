# reads list of relative file paths from file ach cekcs whether each of the file exists in given directory
$cwd = $PSScriptRoot
$dir = "D:\TEMP\FAR"
foreach($relPath in Get-Content "$cwd\filelist1.txt")
{
    #Write-HOst $relPath
    $fullPath = "$dir\$relPath"
    #Write-HOst $fullPath
    if( Test-Path -LiteralPath $fullPath )
    {
        Write-Host "Exists: $fullPath"
    }
}

