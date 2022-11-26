# we are trying to override an existing .net class from an assembly

# there is PowerShellOverrideDotNetClass.BaseClass having
#   virtual void VirtualMethod()
#   normal void CallVirtualMethod()

using assembly 'D:\Work\Powershell\inheritance\PowerShellOverrideDotNetClass.dll'
using namespace PowerShellOverrideDotNetClass

#$inst = [BaseClass]::new()
#$inst.CallVirtualMethod()

# this fails with "unable to find type BaseClass"
#class InheritedClass : BaseClass {
#  [void] VirtualMethod()
#  {
#    Write-Host "overridden from powershell!"
#  }
#}
#

# see https://stackoverflow.com/questions/42837447/powershell-unable-to-find-type-when-using-ps-5-classes/58823343#58823343
Invoke-Expression @'
class InheritedClass : BaseClass {
  [void] VirtualMethod()
  {
    ([BaseClass] $this).VirtualMethod()
    Write-Host "overridden from powershell!"
  }
}
'@

# note: the above is basically the same as calling a second script
# . "$PSScriptRoot\inherited.ps1"

$inst = [InheritedClass]::new()
$inst.CallVirtualMethod()


