<#
.SYNOPSIS
Connects to a Dirigent agent, stops apps, and cleans up, with specific error handling.

.DESCRIPTION
This script performs a full stop-and-cleanup of a Dirigent agent.
It returns a non-zero error code ONLY under the following critical conditions:
- The main polling loop times out waiting for apps to stop.
- The network read times out specifically when waiting for the 'KillAll' command acknowledgment.
- The script finds a Dirigent process but fails to terminate it.

All other errors (e.g., initial connection failure) are logged to the console but the script will exit with code 0.

.PARAMETER Address
The IP address or hostname of the Dirigent master agent. Defaults to '127.0.0.1'.

.PARAMETER Port
The TCP port of the Dirigent master agent. Defaults to 5050.
#>
param(
    [string]$Address = "127.0.0.1",
    [int]$Port = 5050,
    [int]$PollIntervalSeconds = 5,
    [int]$TimeoutSeconds = 300
)

# This flag determines the final exit code. Only specific, critical errors will set it.
$script:criticalErrorOccurred = $false

# Centralized function to ensure the agent processes are terminated in the correct order.
function Invoke-ForceKillAgent {
    param ([string]$Reason = "a script failure")
    Write-Host -ForegroundColor Yellow "Executing cleanup procedure due to $Reason."
    
    foreach ($processName in "Dirigent.Agent.Starter", "Dirigent.Agent") {
        Write-Host "Attempting to find and kill the '$($processName).exe' process..."
        $processToKill = Get-Process -Name $processName -ErrorAction SilentlyContinue
        if ($processToKill) {
            try {
                Write-Host "Found $($processName).exe (PID: $($processToKill.Id)). Forcibly terminating..."
                $processToKill | Stop-Process -Force -ErrorAction Stop
                Write-Host -ForegroundColor Green "$($processName) process terminated."
            }
            catch {
                # --- CRITICAL ERROR CONDITION ---
                # This is the 3rd critical error: we found the process but couldn't kill it.
                Write-Host -ForegroundColor Red "FATAL: Failed to kill process $($processName) (PID: $($processToKill.Id)). Check permissions."
                $script:criticalErrorOccurred = $true
            }
        } else {
            Write-Host -ForegroundColor Yellow "$($processName).exe process not found."
        }
    }
}

function Send-Command($Writer, $Reader, $Command, $RequestId) {
    $commandWithId = "[$($RequestId)] $Command"
    Write-Host "Sending: $commandWithId"
    $Writer.WriteLine($commandWithId)
    $Writer.Flush()

    while ($true) {
        try {
            $response = $Reader.ReadLine()
        }
        catch [System.IO.IOException] {
            # --- CRITICAL ERROR CONDITION ---
            # This is the 2nd critical error: A timeout waiting for the KillAll ACK.
            if ($Command -eq 'KillAll') {
                Write-Host -ForegroundColor Red "FATAL: Network timeout waiting for response to critical 'KillAll' command."
                $script:criticalErrorOccurred = $true
            }
            # Re-throw the exception to be caught by the main catch block for cleanup.
            throw $_
        }

        if ($response -eq $null) {
            if ($Command -eq 'Terminate') {
                Write-Host "Connection closed by server after Terminate command, which is expected."
                return
            }
            throw "Connection closed unexpectedly by the server."
        }
        Write-Host "Received: $response"
        if ($response.StartsWith("[$($RequestId)] ACK")) { return }
        if ($response.StartsWith("[$($RequestId)] ERROR")) { throw "Received error for command '$Command': $response" }
    }
}

try {
    Write-Host "Connecting to $Address on port $Port..."
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.Connect($Address, $Port)
    $stream = $tcpClient.GetStream()
    $stream.ReadTimeout = 5000
    $writer = New-Object System.IO.StreamWriter($stream)
    $reader = New-Object System.IO.StreamReader($stream)
    $writer.NewLine = "`n"

    $reqId = 1
    Send-Command -Writer $writer -Reader $reader -Command "KillAll" -RequestId $reqId

    Write-Host "Waiting for all apps to stop... (Timeout: ${TimeoutSeconds}s)"
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    while ($stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds) {
        $reqId++
        $prefix = "[$($reqId)] "
        $commandWithId = "$prefix" + "GetAllAppsState"
        $writer.WriteLine($commandWithId)
        $writer.Flush()
        $runningApps = 0
        while ($true) {
            $response = $reader.ReadLine()
            if ($response -eq $null) { throw "Connection closed unexpectedly during polling." }
            if (-not ($response.StartsWith($prefix))) { continue }
            $line = $response.Substring($prefix.Length)
            if ($line -eq "END") { break }
            if ($line.StartsWith("APP:")) {
                if ($line.Split(':')[2] -like "*R*") { $runningApps++ }
            }
        }
        if ($runningApps -eq 0) { Write-Host -ForegroundColor Green "Success: All applications have stopped."; break }
        Write-Host "Waiting... $runningApps application(s) still running. Retrying in ${PollIntervalSeconds}s."
        Start-Sleep -Seconds $PollIntervalSeconds
    }

    if ($stopwatch.Elapsed.TotalSeconds -ge $TimeoutSeconds) {
        # --- CRITICAL ERROR CONDITION ---
        # This is the 1st critical error: The main polling loop timed out.
        $script:criticalErrorOccurred = $true
        throw "Timeout: Not all applications stopped within the specified ${TimeoutSeconds}s."
    }

    $reqId++
    Send-Command -Writer $writer -Reader $reader -Command "Terminate" -RequestId $reqId
    Write-Host -ForegroundColor Green "Dirigent Terminate command sent successfully."
    Start-Sleep -Seconds 3
    Invoke-ForceKillAgent -Reason "the successful completion of the script"
}
catch {
    # This main catch block handles ALL failures. It logs them and triggers cleanup.
    # It does NOT determine the exit code; that is handled by the $criticalErrorOccurred flag.
    # WARNING: color must NOT be red, otherwise powershell writes the error to stderr, which we want to avoid!
    Write-Host -ForegroundColor Yellow "An error occurred: $_. Proceeding with cleanup."
    Invoke-ForceKillAgent -Reason "a script failure or timeout"
}
finally {
    if ($tcpClient -and $tcpClient.Connected) {
        Write-Host "Closing TCP connection."
        $tcpClient.Close()
    }
}

# --- FINAL EXIT CODE DETERMINATION ---
if ($script:criticalErrorOccurred) {
    Write-Host -ForegroundColor Red "Script finished with a critical error. Exiting with error code 1."
    exit 1
} else {
    Write-Host -ForegroundColor Green "Script finished successfully or with a non-critical failure. Exiting with code 0."
    exit 0
}
