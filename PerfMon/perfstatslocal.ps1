$LogFile = "$PSScriptRoot\PerfStats.txt"

while ($true) {
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $MemoryUsage = (Get-Counter '\Memory\% Committed Bytes In Use').CounterSamples.CookedValue
    $CPUUsage = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $DirigentRunning = if (Get-Process -Name "Dirigent.Agent" -ErrorAction SilentlyContinue) { 1 } else { 0 }
    
    $LogEntry = "[$TimeStamp] RAM {0:00}%, CPU {1:00}%, Dirigent {2}" -f $MemoryUsage, $CPUUsage, $DirigentRunning
    Write-Host $LogEntry
    Add-Content -Path $LogFile -Value $LogEntry
    
    Start-Sleep -Seconds 60
}
