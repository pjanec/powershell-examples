# Locates files listed in the list file, finds them in given directory; calculate hash from their names, date and size
function Get-FileListHashShallow
{
    Param (
        [string]$listFile, # list of files to calculate the hash from
        [string]$dir # what directory to expect the files in
         )

    $lines = [System.Collections.ArrayList]@()

    foreach($relPath in Get-Content $listFile)
    {
        $fullPath = "$dir\$relPath"
        if( Test-Path -LiteralPath $fullPath )
        {
            $fi = Get-Item $fullPath # file info
        
            # format the file info as a compact string
            $timeStamp = $fi.LastWriteTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
            $length = $fi.Length
            $line = "{0}|{1}|{2}" -f ($relPath, $timeStamp, $length)
            [void]$lines.Add($line)
        }
    }

    # write the lines to tmp file
    $tmpFile = [System.IO.Path]::GetTempFileName()
    $lines | Out-File $tmpFile

    # calc hash of it
    $hash = Get-FileHash -Path $tmpFile
    #$hash | Get-Member

    Remove-Item $tmpFile

    return $hash.Hash # the string
}


# Find files listed in given directory; return a list of relative paths
function Get-DirFileList
{
    Param ([string]$dir)

    $origLoc = Get-Location
    $lines = [System.Collections.ArrayList]@()
    Set-Location $dir
    Get-ChildItem $dir -Recurse -File | sort FullName |
    Foreach-Object {
        $line = $_.FullName | Resolve-Path -Relative
        [void]$lines.Add($line)
    }
    Set-Location $origLoc
    return $lines
}

function Create-DirFileListFile
{
    Param ([string]$listFile, [string]$dir)
    $list = Get-DirFileList $dir
    $list | Out-File $listFile
}


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
        # format the file info as a compact string
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


#Get-DirHashShallow "D:\TEMP\FAR"

$listf = "$PSScriptRoot\filelist2.txt"
$dirPath = "D:\TEMP\FAR"
Create-DirFileListFile $listf $dirPath
$hash = Get-FileListHashShallow $listf $dirPath
Write-HOst $hash


