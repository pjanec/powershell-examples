# two script approach

# dynamically load the base class assembly
Add-Type -Path "$PSScriptRoot\PowerShellOverrideDotNetClass.dll"

# load our class inherited from a base class
. "$PSScriptRoot\inherited.ps1"

$inst = [InheritedClass]::new()
$inst.CallVirtualMethod()

