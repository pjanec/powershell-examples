function Get-FileStamp
{
    Param([string]$relPath, [System.IO.FileInfo]$fi)
    $timeStamp = $fi.LastWriteTimeUtc.ToString("yyyy-MM-dd HH:mm:ss")
    $length = $fi.Length
    $stamp = "{0}|{1}|{2}" -f ($relPath, $length, $timeStamp)
    return $stamp
}


# Locates files listed in the list file, finds them in given directory; calculate has from their names, dat and size
function Get-FileListHashShallow
{
    Param (
        [string]$listFile, # list of files to calculate the hash from
        [string]$dir # what directory to expect the files in
         )

    $lines = [System.Collections.ArrayList]@()

    foreach($line in Get-Content $listFile)
    {
        if(($_.FullName -like "*\.git\*") -or ($_.FullName -like "*\.svn\*") )  { return }

        $relPath = $line.Split("|")[0] # first part of line = relative path
        $fullPath = "$dir\$relPath"
        if( Test-Path -LiteralPath $fullPath )
        {
            $fi = Get-Item $fullPath
            $stamp = Get-FileStamp $relPath $fi
            [void]$lines.Add($stamp)
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
        if(($_.FullName -like "*\.git\*") -or ($_.FullName -like "*\.svn\*") )  { return }
        $relPath = $_.FullName | Resolve-Path -Relative
        $stamp = Get-FileStamp $relPath $_
        [void]$lines.Add($stamp)
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
        if(($_.FullName -like "*\.git\*") -or ($_.FullName -like "*\.svn\*") )  { return }
        $relPath = $_.FullName | Resolve-Path -Relative
        # format the file info as a compact string
        $stamp = Get-FileStamp $relPath $_
        [void]$lines.Add($stamp)
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

# Checks files from filelist, compare with files in given dir, return list of differences
# Returns list of differences; empty list = identical
function Find-Differences
{
    Param (
        [string]$listFile, # list of files to calculate the hash from
        [string]$dir # what directory to expect the files in
         )

    $diffs = [System.Collections.ArrayList]@()

    foreach($line in Get-Content $listFile)
    {
        $relPath = $line.Split("|")[0] # first part of line = relative path
        $fullPath = "$dir\$relPath"
        if( Test-Path -LiteralPath $fullPath )
        {
            $fi = Get-Item $fullPath
            $stamp = Get-FileStamp $relPath $fi
            # compare
            if( $stamp -ne $line )
            {
                [void]$diffs.Add("DIFFERENT|$line")
            }

            [void]$lines.Add($stamp)
        }
        else
        {
            [void]$diffs.Add("MISSING|$line")
        }
    }

    return $diffs # list of differences; empty=identical (no fil
}


#Get-DirHashShallow "D:\TEMP\FAR"

$listf = "$PSScriptRoot\filelist2.txt"
$srcDirPath = "D:\TEMP\FAR"
$dstDirPath = "D:\TEMP\FAR2"
Create-DirFileListFile $listf $srcDirPath
$hash = Get-FileListHashShallow $listf $srcDirPath
Write-HOst $hash

$diffs = Find-Differences $listf $dstDirPath
if( $diffs.Count -eq 0 ) { Write-Host "Identical" } else { Write-Host "Differences:", $diffs }

