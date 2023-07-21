function ReplaceOutputType
{
    Param( [string]$csprojFileName, [string]$newPlatform )

    (Get-Content -path $csprojFileName) | % {
      $_ -Replace '<OutputType>[^\<]*</OutputType>', "<OutputType>$newPlatform</OutputType>"
     } |
     Out-File -encoding utf8 $csprojFileName
}

