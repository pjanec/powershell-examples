Import-Module -Force  "$PSScriptRoot\dirhash.psm1"


#$listf = "$PSScriptRoot\filelist2.txt"
#$srcDirPath = "D:\TEMP\FAR"
#$dstDirPath = "D:\TEMP\FAR2"
#New-DirFileListFile $listf $srcDirPath
#$hash = Get-FileListHashShallow $listf $srcDirPath
#Write-HOst $hash

#$diffs = Find-Differences $listf $dstDirPath
#if( $diffs.Count -eq 0 ) { Write-Host "Identical" } else { Write-Host "Differences:", $diffs }


New-DirFileListFile "$PSScriptRoot\filelist3.txt" D:\Work\SimIG\DistRepo\
