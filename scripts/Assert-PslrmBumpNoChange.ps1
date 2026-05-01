[CmdletBinding()]
param(
    [AllowEmptyString()]
    [string] $Result = $env:RESULT,

    [AllowEmptyString()]
    [string] $BumpBranchName = $env:BUMP_BRANCH_NAME,

    [AllowEmptyString()]
    [string] $PullRequestNumber = $env:PULL_REQUEST_NUMBER
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Result -ne 'no_change') {
    throw "Expected result=no_change, but got '$Result'."
}

if (-not [string]::IsNullOrWhiteSpace($BumpBranchName)) {
    throw "Expected bump_branch_name to be empty, but got '$BumpBranchName'."
}

if (-not [string]::IsNullOrWhiteSpace($PullRequestNumber)) {
    throw "Expected pull_request_number to be empty, but got '$PullRequestNumber'."
}

Write-Host 'No-change validation passed with result=no_change.'
