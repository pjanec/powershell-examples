$vsWhere = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"   
$vsInstallationPath = & $vsWhere -products * -latest -property installationPath
& "${vsInstallationPath}\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64 -SkipAutomaticLocation

MSBuild "path\to\your\project\MySolution.sln" -target:MyProject -property:Configuration=Release -property:Platform="x64" -verbosity:quiet

if( $LastExitCode -eq 0 )
{
    "Build succeeded."
}
else
{
    throw "Build failed."
}
