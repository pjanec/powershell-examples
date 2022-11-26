# hash all files in directory including subdirs; Takes just file names, last write time and size, NOT THE CONTENT!
function Get-DirHashShallow
{
    Param ([string]$dir)

    $origLoc = Get-Location
    Write-host "OrigLoc: $origLoc"

    $lines = [System.Collections.ArrayList]@()
    Set-Location $dir
    Get-ChildItem $dir -Recurse -File | sort FullName |
    Foreach-Object {
        $relPath = $_.FullName | Resolve-Path -Relative
        $timeStamp = $_.LastWriteTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
        $length = $_.Length
        $line = "{0}|{1}|{2}" -f ($relPath, $timeStamp, $length)
        [void]$lines.Add($line)
    }
    #Write-host $lines

    Set-Location $origLoc

    # write the lines to tmp file
    $tmpFile = [System.IO.Path]::GetTempFileName()
    $lines | Out-File $tmpFile

    # calc hash of it
    $hash = Get-FileHash -Path $tmpFile
    #$hash | Get-Member

    Remove-Item $tmpFile

    return $hash.Hash # the string
}


Get-DirHashShallow "D:\TEMP\FAR"
