<#
.SYNOPSIS
    This script is designed to be run by a service under the LocalSystem account.
    It finds the currently active, interactive user session and launches a specified
    batch script in that user's context using only built-in Windows tools.

.DESCRIPTION
    Windows services run in an isolated environment (Session 0) and cannot directly
    start GUI applications on a user's desktop. This script overcomes that isolation
    by using the Windows Task Scheduler.

    It works as follows:
    1. Uses the command-line tool 'quser.exe' to find the session ID and username of
       the 'Active' user console session.
    2. Creates a temporary, one-off scheduled task configured to run as that specific user.
    3. The task is given a one-time trigger in the past to make it valid, but it is not
       meant to run on a schedule.
    4. The script then manually starts the task on demand.
    5. After a brief pause to allow the task to launch, the script deletes the
       temporary task, leaving no trace.

.NOTES
    Author: Gemini
    Version: 2.3

    Prerequisites:
    - This script requires no external tools and is designed for broad compatibility.
    - The LocalSystem account needs permissions to create and manage scheduled tasks.
      This is typically enabled by default.

    Service Configuration: The service must be configured to run this PowerShell script.
       Example command for the service to execute:
       powershell.exe -ExecutionPolicy Bypass -NoProfile -File "C:\Path\To\This\Script.ps1"
#>

# Full path to the batch script you want to run for the user.
$userBatchScript = " $PSScriptRoot\UserScript.bat"


# --- SCRIPT LOGIC ---

Write-Output "Script started. Searching for an active user session..."

# Find the active user session using `quser`.
# We parse the output to find a session that is in the 'Active' state.
$activeSessionLine = (quser) | Select-String -Pattern 'Active' | Select-Object -First 1

if ($null -ne $activeSessionLine) {
    # Parse the line to get the username and session ID.
    # The output of quser is space-delimited. We remove empty entries.
    $sessionInfo = $activeSessionLine.ToString().Trim() -split '\s+'

    # FIX: The active username from 'quser' is often prefixed with '>'.
    # We must remove it to get a valid account name.
    $username = $sessionInfo[0].TrimStart('>')

    # The session ID can be found by filtering for a number
    $sessionId = ($sessionInfo | Where-Object { $_ -match '^\d+$' } | Select-Object -First 1)

    if ($username -and $sessionId) {
        Write-Output "Found active user '$username' in session $sessionId"

        if (-not (Test-Path $userBatchScript)) {
            Write-Error "User batch script not found at specified path: $userBatchScript"
            exit 1
        }

        # Generate a unique name for the temporary task.
        $taskName = "LaunchGuiForUser-$(Get-Date -Format 'yyyyMMddHHmmssffff')"

        # Define the action for the task (i.e., what command to run).
        $taskAction = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$userBatchScript`""

        # Define the user principal for the task. This is the key part.
        # It sets the task to run under the logged-in user's account.
        # -LogonType Interactive is crucial for the GUI to be visible.
        $taskPrincipal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive

        # FIX FOR COMPATIBILITY: A task requires a trigger to be valid. We'll create a
        # one-time trigger set for the past. This makes the task valid for registration
        # but does not schedule it to run.
        $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddYears(-1)

        # Define task settings. These are mostly defaults but ensure it runs properly.
        $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

        try {
            Write-Output "Registering temporary scheduled task: $taskName"
            # Register the task with the system. The -Trigger parameter is included to ensure validity.
            Register-ScheduledTask -TaskName $taskName -Action $taskAction -Principal $taskPrincipal -Trigger $trigger -Settings $taskSettings | Out-Null

            Write-Output "Starting task..."
            # Manually start the task we just created.
            Start-ScheduledTask -TaskName $taskName

            # Give the task a moment to start before we delete it.
            # A short delay is often necessary for the scheduler to kick off the process.
            Start-Sleep -Seconds 3

            Write-Output "Unregistering temporary task..."
            # Clean up by deleting the task.
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false

            Write-Output "Scheduled task method completed successfully."
        }
        catch {
            Write-Error "An error occurred with the scheduled task method: $_"
            # Attempt to clean up the task in case of failure during the 'try' block.
            if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
                Write-Warning "Cleaning up failed task: $taskName"
                Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
            }
            exit 1
        }
    }
    else {
        Write-Warning "Could not determine username or session ID from active session line: '$activeSessionLine'"
    }
}
else {
    Write-Warning "No active user session found. The script will now exit."
}

# --- END OF SCRIPT ---
