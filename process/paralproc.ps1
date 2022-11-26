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



$p = Start-Process "cmd.exe" -WorkingDirectory "C:\" -NoNewWindow -PassThru
Start-Sleep 1

# set the application to foreground
[void] [StartActivateProgramClass]::SetForegroundWindow($p.MainWindowHandle)

# send the keys sequence
# more info on MSDN at http://msdn.microsoft.com/en-us/library/System.Windows.Forms.SendKeys(v=vs.100).aspx
[System.Windows.Forms.SendKeys]::SendWait("^c")

Start-Sleep 2

Stop-Process -InputObject $p

