# this script is called from the main to load the class definition

class InheritedClass : PowerShellOverrideDotNetClass.BaseClass {
  [void] VirtualMethod()
  {
    # call parent class
    ([PowerShellOverrideDotNetClass.BaseClass] $this).VirtualMethod()

    Write-Host "overridden from powershell!"
  }
}

