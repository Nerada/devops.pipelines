param($officialBuild)

Push-Location $PSScriptRoot

if($officialBuild -ne "official-build")
{
	$user = $env:UserName 
}

try
{
    git | Out-Null
	
	$branch = git symbolic-ref --short -q HEAD
	# HEAD is probably detached, the build server alsways builds detached so lets check if we can get the build server environment var
	if(([string]::IsNullOrEmpty($branch))){$branch = $env:BUILD_SOURCEBRANCH -replace "refs/heads/", ""}
	
	$gitRef = git describe --always --abbrev=6 --dirty --exclude '*'
}
catch [System.Management.Automation.CommandNotFoundException]
{
	Write-Output "Caught exception: $($PSItem.ToString())"
}

$buildTime = [System.DateTimeOffset]::Now.ToString("o")

if(!([string]::IsNullOrEmpty($user))){$user += "|"}
if(!([string]::IsNullOrEmpty($branch))){$branch += "|"}
if(!([string]::IsNullOrEmpty($gitRef))){$gitRef += "|"}

$user + $branch + $gitRef + $buildTime

Pop-Location