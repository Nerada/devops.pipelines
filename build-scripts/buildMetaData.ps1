param($officialBuild)

Push-Location $PSScriptRoot

if($officialBuild -ne "official-build"){$user = $env:UserName}

try
{
    git | Out-Null # if this throws, you need to install git
    
    # The build server alsways builds with HEAD detached so lets check if we can use the build server environment var
    # See the Build.SourceBranch section of https://learn.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml 
    if (![string]::IsNullOrEmpty($env:BUILD_SOURCEBRANCH)) 
    { 
        $branch = Switch -regex ($env:BUILD_SOURCEBRANCH)
        {
            '^refs/heads/'            {$env:BUILD_SOURCEBRANCH -replace '^refs/heads/',            ''}
            '^refs/tags/'             {$env:BUILD_SOURCEBRANCH -replace '^refs/tags/',             ''}
            '^refs/pull/(\d+)/merge$' {$env:BUILD_SOURCEBRANCH -replace '^refs/pull/(\d+)/merge$', 'pr-$1-merge'}
            Default                   {$env:BUILD_SOURCEBRANCH}
        }
    } 
    else 
    { 
        $gitSymbolicRef = git symbolic-ref --short -q HEAD 
        $branch = if (![string]::IsNullOrEmpty($gitSymbolicRef)) {$gitSymbolicRef} else {"detached-head"}
    } 
    
    $sha = git describe --always --abbrev=6 --dirty --exclude '*'
}
catch
{
    Write-Output "Caught exception: $($PSItem.ToString())"
}

$buildTime = [System.DateTimeOffset]::Now.ToString("o")

if(!([string]::IsNullOrEmpty($user)))  {$user   += "|"}
if(!([string]::IsNullOrEmpty($branch))){$branch += "|"}
if(!([string]::IsNullOrEmpty($sha)))   {$sha    += "|"}

$user + $branch + $sha + $buildTime

Pop-Location