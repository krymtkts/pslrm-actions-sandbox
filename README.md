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
- Trigger: `workflow_dispatch`
- Permissions: `contents: write` and `pull-requests: write`

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
