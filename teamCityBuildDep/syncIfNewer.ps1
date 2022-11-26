$watchedBuildName="BIG-CI-master"
$checkoutInfoFile="$PSScriptRoot\BIG-CI-master-work-dir.txt" #"%teamcity.agent.home.dir%\$watchedBuildName"+"-work-dir.txt"
$successInfoFile="$PSScriptRoot\BIG-CI-master-success.txt" #"%teamcity.agent.home.dir%\$watchedBuildName"+"-success.txt"
$ourLastRunFile = "$PSScriptRoot\CI-master-SyncToSvn-last-run.txt"#"%teamcity.agent.home.dir%\%system.teamcity.projectName%-%system.teamcity.buildConfName%-last-run.txt"

$minAge = 60


# if our last dependency build was not succesfull, exit early
if( -not ( Test-Path -LiteralPath "$successInfoFile" -PathType Leaf ) )
{
	"Latest $watchedBuildName not succesfull or missing"
    exit 0
}

# check if the the dependency build (CI-master) is newer than our last run
$runSync = $false
# if we have not run yet, do the sync now
if( !(Test-Path -LiteralPath "$ourLastRunFile" -PathType Leaf ))
{
    "We have never run yet"
	$runSync = $true
}
else
{
    # if there is newer build than our last run time, sync
    $ourLastRunTime = (Get-Item $ourLastRunFile).LastWriteTime
    $depLastRunTime = (Get-Item $successInfoFile).LastWriteTime
    if( $depLastRunTime -gt $ourLastRunTime )
    {
        $depAge = [Math]::Round(($depLastRunTime - $ourLastRunTime).TotalMinutes+0.05,1)

        "$watchedBuildName is newer than our last run (by $depAge minutes)"

        # how much older the dependency build is relative to our own last run
        if( $depAge -gt $minAge )
        {
    	    $runSync = $true
        }
        else
        {
            "Sorry, not older than $minAge"
        }
    }
    else
    {
	    "no new succesfull build of $watchedBuildName"
    }
}

# try the sync if time check passed
if( $runSync )
{
    # get the checkout dir of our dependency build
    $checkoutDir = ""
    if( Test-Path -LiteralPath "$checkoutInfoFile" -PathType Leaf )
    {
        $checkoutDir = (Get-Content "$checkoutInfoFile" -First 1).Trim()
    }
    else
    {
        "checkoutdir file does not exist! $checkoutDir"
    }

    if( [string]::IsNullOrEmpty($checkoutDir) )
    {
        "Can't determine checkout dir for $watchedBuildName!"
        exit 1
    }

	# launch the sync process
	$syncSuccess = $false
    $procWorkDir = "$checkoutDir\Projects\BIG\Tools\SyncDistToSvn"
    $procFullPath = "$procWorkDir\sync.bat"
    "Launching $procFullPath..."
    #Push-Location $procWorkDir
    #& $procFullPath
    #$procExitCode = $LASTEXITCODE
	#"Sync returned exit code $procExitCode"
    #if( $procExitCode -eq 0 ) { $syncSuccess = $true }
    #Pop-Location
    $syncSuccess = $true
    
    if( $syncSuccess )
    {
      # update our last successful run time marker by re-creating the marker file
      New-Item -Path $ourLastRunFile -ItemType "file" -Force -Value "xxx" | Out-Null
    }
    

}
else
{
	"No sync this time..."
}
