$ComputerIPs = @(
    "127.0.0.1"
    )
    

foreach ($ComputerIP in $ComputerIPs) {
    $RemoteLogFile = "$PSScriptRoot\$ComputerIP.txt"

    while ($true) {
        $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $MemoryUsage = Invoke-Command -ComputerName $ComputerIP -ScriptBlock {
            (Get-Counter '\Memory\% Committed Bytes In Use').CounterSamples.CookedValue
        }
        $CPUUsage = Invoke-Command -ComputerName $ComputerIP -ScriptBlock {
            (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
        }
        $DirigentRunning = Invoke-Command -ComputerName $ComputerIP -ScriptBlock {
            if (Get-Process -Name "Dirigent.Agent" -ErrorAction SilentlyContinue) { 1 } else { 0 }
        }

        $LogEntry = "[$TimeStamp] RAM {0:00}%, CPU {1:00}%, Dirigent {2}" -f $MemoryUsage, $CPUUsage, $DirigentRunning
        Write-Host "[$ComputerIP] $LogEntry"
        Add-Content -Path $RemoteLogFile -Value $LogEntry

        Start-Sleep -Seconds 60
    }
}