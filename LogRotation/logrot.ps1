# this script defines a set of log files in different folders.
# the goal is to perform the log rotation on these files.
# for each file, if it is longer than defined size, it will be renamed to a new file with a timestamp suffix.
# the original file will be truncated to 0.
# the number of backup files is limited to 5.

# define the log file size limit
$sizeLimit = 10KB

# define the log file path list
$logFiles = @(
    "C:\temp\log1.log",
    "C:\temp\log2.log",
    "C:\temp\log3.log"
)

# loop through each log file
foreach ($logFile in $logFiles) {
    # check if the log file exists
    if (Test-Path $logFile) {
        # get the log file size
        $fileSize = (Get-Item $logFile).length
        # check if the log file size exceeds the limit
        if ($fileSize -gt $sizeLimit) {
            # get the current timestamp
            $timestamp = Get-Date -Format "yyyyMMddHHmmss"
            # define the backup file name with timestamp suffix
            $backupFile = $logFile -replace "\.log$", "_$timestamp.log"
            # rename the log file to the backup file
            Rename-Item -Path $logFile -NewName $backupFile
            # truncate the log file to 0
            Clear-Content -Path $logFile
            # get the list of backup files
            $backupFiles = Get-ChildItem -Path (Split-Path $logFile) -Filter "*.log" | Sort-Object -Property LastWriteTime -Descending
            # keep only the latest 5 backup files
            $backupFiles | Select-Object -Skip 5 | Remove-Item -Force
        }
    }
}
