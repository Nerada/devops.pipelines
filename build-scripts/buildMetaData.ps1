param($officialBuild)

if($officialBuild -ne "official-build")
{
	$user = $env:UserName 
}

try
{
    git | Out-Null
	
	$branch = git symbolic-ref --short -q HEAD
	if(([string]::IsNullOrEmpty($branch))){$branch = $(Build.SourceBranch) -replace "refs/heads/", ""}
	
	$gitRef = git describe --always --abbrev=6 --dirty --exclude '*'
}
catch [System.Management.Automation.CommandNotFoundException]{}

$buildTime = [System.DateTimeOffset]::Now.ToString("o")

if(!([string]::IsNullOrEmpty($user))){$user += "|"}
if(!([string]::IsNullOrEmpty($branch))){$branch += "|"}
if(!([string]::IsNullOrEmpty($gitRef))){$gitRef += "|"}

$user + $branch + $gitRef + $buildTime