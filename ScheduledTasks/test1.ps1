Write-output $MyInvocation.MyCommand.Path

$t = Get-ScheduledTask -TaskName "PjTest1"
Write-output "State: $($t.State)"
exit
$t.State.GetType()

if( $t.State -eq "Running" )
{
    Write-Output "Running!"
}

if( $t.State -eq "Ready" )
{
    Write-Output "Ready!"
}
