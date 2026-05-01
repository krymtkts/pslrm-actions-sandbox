[CmdletBinding()]
param(
    [AllowEmptyString()]
    [string] $Result = $env:RESULT,

    [AllowEmptyString()]
    [string] $BumpBranchName = $env:BUMP_BRANCH_NAME,

    [AllowEmptyString()]
    [string] $PullRequestNumber = $env:PULL_REQUEST_NUMBER,

    [AllowEmptyString()]
    [string] $BaseBranch = $env:BASE_BRANCH,

    [AllowEmptyString()]
    [string] $BumpBranchPrefix = $env:BUMP_BRANCH_PREFIX,

    [AllowEmptyString()]
    [string] $LockfilePath = $env:LOCKFILE_PATH,

    [AllowEmptyString()]
    [string] $RepositoryFullName = $env:REPOSITORY_FULL_NAME
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Result -notin @('created', 'updated', 'noop')) {
    throw "Expected result to be one of 'created', 'updated', or 'noop', but got '$Result'."
}

if ([string]::IsNullOrWhiteSpace($BumpBranchName)) {
    throw 'Expected bump_branch_name to be populated for a changed run.'
}

if ([string]::IsNullOrWhiteSpace($PullRequestNumber)) {
    throw 'Expected pull_request_number to be populated for a changed run.'
}

if ([string]::IsNullOrWhiteSpace($BaseBranch)) {
    throw 'Expected base_branch to be populated for a changed run.'
}

if ([string]::IsNullOrWhiteSpace($BumpBranchPrefix)) {
    throw 'Expected bump_branch_prefix to be populated for a changed run.'
}

if ([string]::IsNullOrWhiteSpace($LockfilePath)) {
    throw 'Expected lockfile_path to be populated for a changed run.'
}

if ([string]::IsNullOrWhiteSpace($RepositoryFullName)) {
    throw 'Expected repository_full_name to be populated for a changed run.'
}

if (-not $BumpBranchName.StartsWith($BumpBranchPrefix)) {
    throw "Expected bump branch prefix '$BumpBranchPrefix', but got '$BumpBranchName'."
}

$pullRequestJson = @(gh pr view $PullRequestNumber --repo $RepositoryFullName --json 'number,headRefName,baseRefName,files') | Select-Object -Last 1
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($pullRequestJson)) {
    throw "Failed to inspect bump pull request #$PullRequestNumber."
}

$pullRequest = $pullRequestJson | ConvertFrom-Json
if ([string] $pullRequest.headRefName -cne $BumpBranchName) {
    throw "Expected pull request #$PullRequestNumber head branch '$BumpBranchName', but got '$($pullRequest.headRefName)'."
}

if ([string] $pullRequest.baseRefName -cne $BaseBranch) {
    throw "Expected pull request #$PullRequestNumber base branch '$BaseBranch', but got '$($pullRequest.baseRefName)'."
}

$changedFiles = @(foreach ($file in @($pullRequest.files)) { [string] $file.path }) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
if ($changedFiles -notcontains $LockfilePath) {
    throw "Expected pull request #$PullRequestNumber to include '$LockfilePath', but got: $($changedFiles -join ', ')"
}

$remoteBranchHead = @(git ls-remote --heads origin "refs/heads/$BumpBranchName") | Select-Object -Last 1
if ($LASTEXITCODE -ne 0) {
    throw "Failed to inspect remote bump branch '$BumpBranchName'."
}

if ([string]::IsNullOrWhiteSpace($remoteBranchHead)) {
    throw "Expected remote bump branch '$BumpBranchName' to exist."
}

Write-Host "Has-changes validation passed with result '$Result', PR #$PullRequestNumber on '$BumpBranchName'."
