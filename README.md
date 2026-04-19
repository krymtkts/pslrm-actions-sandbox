# pslrm Actions Sandbox

This repository is a consumer-side sandbox for `pslrm-*` GitHub Actions.

This repository covers [`krymtkts/pslrm-bump-action`](https://github.com/krymtkts/pslrm-bump-action).

## Workflows

### `pslrm-bump-no-change`

This workflow will run against `projects/no-change-project`.

- Purpose: confirm `pslrm-bump-action` reports `changed=false` when the lockfile is up to date.
- File: `.github/workflows/pslrm-bump-no-change.yml`
- Trigger: `workflow_dispatch`
- Permissions: `contents: read`

### `pslrm-bump-has-changes`

This workflow will run against `projects/stale-lockfile-project`.

- Purpose: confirm branch creation, commit, push, and pull request create-or-update behavior.
- Prerequisite: turn on `Allow GitHub Actions to create and approve pull requests`.
- Token: this workflow uses `GITHUB_TOKEN`.
- Trigger: `workflow_dispatch`
- Permissions: `contents: write` and `pull-requests: write`

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
- `projects/stale-lockfile-project`: fixture for stable `changed=true` validation.

## Cleanup

After a live validation run finishes, clean up the repository state.

- Close the validation pull request when no longer needed.
- Delete the validation branch after reviewing the result.
- Restore the stale-lockfile fixture to its intended stale state.
- Keep the next live run on the same validation path.

## License

This repository uses the MIT License.
