for /f %%i in ('powershell -ExecutionPolicy UnRestricted get-date -f yyyyMMdd_HHmmss') do set TIMESTAMP=%%i
echo %TIMESTAMP%

