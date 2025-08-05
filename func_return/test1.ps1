function GetResults
{
  # powershell array of string - days in a weeks
  $days = @("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  $days | ForEach-Object {
    return $_
  }
  #foreach ($day in $days) {
  #  Write-Host "Day: $day"
  #  return $day
  #}
  return "NO_RESULT"
}

$result = GetResults

Write-Host "Result: $result"
