param (
    [Parameter(Mandatory=$True,Position=1)]
    [string]
    $ApplicationTitle,

    [Parameter(Mandatory=$True,Position=2)]
    [string]
    $Keys,

    [Parameter(Mandatory=$false)]
    [int] $WaitTime
    )

# load assembly cotaining class System.Windows.Forms.SendKeys
[void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#Add-Type -AssemblyName System.Windows.Forms

# add a C# class to access the WIN32 API SetForegroundWindow
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class StartActivateProgramClass {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
    }
"@

# get the applications with the specified title
$p = Get-Process | Where-Object { $_.MainWindowTitle -eq $ApplicationTitle }
if ($p) 
{
    # get the window handle of the first application
    $h = $p[0].MainWindowHandle
    # set the application to foreground
    [void] [StartActivateProgramClass]::SetForegroundWindow($h)

    # send the keys sequence
    # more info on MSDN at http://msdn.microsoft.com/en-us/library/System.Windows.Forms.SendKeys(v=vs.100).aspx
    [System.Windows.Forms.SendKeys]::SendWait($Keys)
    if ($WaitTime) 
    {
        Start-Sleep -Seconds $WaitTime
    }
}
