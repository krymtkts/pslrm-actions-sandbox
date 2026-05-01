# pslrm Actions Sandbox

This repository is a consumer-side sandbox for `pslrm-*` GitHub Actions.

This repository covers [`krymtkts/pslrm-bump-action`](https://github.com/krymtkts/pslrm-bump-action).

## Workflows

### `pslrm-bump-no-change`

This workflow will run against `projects/no-change-project`.

- Purpose: confirm `pslrm-bump-action` reports `changed=false` when the lockfile is up to date.
- Ref coverage: `@main`, `@v0.0.1-alpha`, and `@v0`.
- Platform coverage: `core` and Windows PowerShell (`target-powershell-edition=desktop`).
- File: `.github/workflows/pslrm-bump-no-change.yml`
- Trigger: `workflow_dispatch`
- Permissions: `contents: read`

### `pslrm-bump-has-changes`

This workflow will run against dedicated `projects/stale-lockfile-*` fixtures.

- Purpose: confirm each ref / PowerShell case can handle its own bump branch / pull request path.
- Ref coverage: `@main`, `@v0.0.1-alpha`, and `@v0`.
- Platform coverage: `core` and Windows PowerShell (`target-powershell-edition=desktop`).
- Fixture model: every case uses its own stale lockfile copy and its own module name.
- Expected result: every case should return `result=created`, `updated`, or `noop`.
- Execution model: distinct module names keep the bump branches separate within one run.
- Prerequisite: turn on `Allow GitHub Actions to create and approve pull requests`.
- Token: this workflow uses `GITHUB_TOKEN`.
- Trigger: `workflow_dispatch`
- Permissions: `contents: write` and `pull-requests: write`

> [!NOTE]
> The exact-tag jobs track only the current public exact release tag.
> When a new exact release is published, update those jobs to the new tag instead of accumulating older exact-tag jobs.

You can verify the repository setting with GitHub CLI:

```powershell
gh api --method GET repos/krymtkts/pslrm-actions-sandbox/actions/permissions/workflow
```

The setting is on when `can_approve_pull_request_reviews` is `true`.
You can enable it with:

```powershell
gh api --method PUT repos/krymtkts/pslrm-actions-sandbox/actions/permissions/workflow `
  -f default_workflow_permissions=read `
  -F can_approve_pull_request_reviews=true
```

## Fixtures

- `projects/no-change-project`: fixture for stable `changed=false` validation.
- `projects/stale-lockfile-main-core`: stale `pocof` fixture for `@main` on `core`.
- `projects/stale-lockfile-main-desktop`: `Get-GzipContent` fixture for `@main` on Windows PowerShell.
- `projects/stale-lockfile-exact-core`: `SnippetPredictor` fixture for exact-tag `core`.
- `projects/stale-lockfile-exact-desktop`: `PSGameOfLife` fixture for exact-tag Windows PowerShell.
- `projects/stale-lockfile-major-core`: `Pester` fixture for `@v0` on `core`.
- `projects/stale-lockfile-major-desktop`: `PSScriptAnalyzer` fixture for `@v0` on Windows PowerShell.

## Assertion scripts

- `scripts/Assert-PslrmBumpNoChange.ps1`
  - Validates `result=no_change` plus empty branch / PR outputs.
- `scripts/Assert-PslrmBumpHasChanges.ps1`
  - Validates `result=created|updated|noop` plus case-specific branch / pull request state.

## Cleanup

After a live validation run finishes, clean up the repository state.

- Close the validation pull requests when no longer needed.
- Delete the validation branches after reviewing the results.
- Keep the stale fixtures on the default branch in their intended stale state.
- Before rerunning `has-changes`, clean up the prior validation pull requests and branches.
- Keep the next live run on the same validation path.

## License

This repository uses the MIT License.
