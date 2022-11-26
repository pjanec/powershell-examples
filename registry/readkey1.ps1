$teamCityInstallPath = (Get-ItemProperty -path 'HKLM:\SOFTWARE\WOW6432Node\JetBrains\TeamCity\Server').InstallPath
"$teamCityInstallPath"

