$proc = Get-Process "chrome" -ErrorAction SilentlyContinue
if ($proc)
{
  "Chrome IS running"
}
else
{
  "Chrome NOT running"
}