param($officialBuild)

if($officialBuild -ne "official-build")
{
	$user = $env:UserName 
	$user += "|"
}

try
{
    git | Out-Null
	
	$branch = git symbolic-ref --short -q HEAD
	$branch += "|"
	$gitRef = git describe --always --abbrev=6 --dirty --exclude '*'
	$gitRef += "|"
}
catch [System.Management.Automation.CommandNotFoundException]{}

$buildTime = [System.DateTimeOffset]::Now.ToString("o")

$user + $branch + $gitRef + $buildTime