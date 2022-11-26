$myDir = Split-Path $MyInvocation.MyCommand.Path
Set-Location -Path $myDir
Write-Host("pwd: $pwd")

# read data model from 
Add-Type -Path "..\bin\Newtonsoft.Json.dll" # reference of ConfigDM
Add-Type -Path "..\Common\ConfigDM.cs" -ReferencedAssemblies @("..\bin\Newtonsoft.Json.dll")
$DM = [ConfigDM.FileUtils]::ReadFromFile("test.json")
$DM.CurrentEndpoint = $DM.Endpoints[0]

Write-Host("Endpoints[0].Machine: $($DM.Endpoints[0].Machine)")
foreach ($m in $DM.Machines)
{
    Write-Host($m.IpAddress)
}

#Add-Type -Path "..\bin\Scriban.dll" # reference of ConfigGen
#Add-Type -Path "..\Common\ConfigGenTools.cs" -ReferencedAssemblies @("..\bin\Scriban.dll")
#[ConfigGen.FileUtils]::RenderTemplateFileToFile("template.tmpl", "output.txt", $DM );


#$DM = 11 # this variable will be seen by the sub-script

. .\cascade-sub.ps1

# call template scripts from all subfolders
Get-ChildItem "."  -include *.tmpl.ps1 -Recurse |
Foreach-Object {
    Write-Host "$_"
    . $_
}
