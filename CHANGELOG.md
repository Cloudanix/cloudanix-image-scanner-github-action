# Changelog

<!--
Every merge to main releases the version in the top "## vX.Y.Z" heading
(.github/workflows/release.yml). Collect changes under "## Unreleased" on
develop; in the PR to main, rename it to the next version and update the
README's "Example usage" tag and "Upgrading" table to match.
scripts/release-check.sh fails the PR until all three agree.
-->

## v0.0.12

- Bumped the `Dockerfile`'s `FROM cloudanix/container-image-scanner` pin from `:v0.0.26` to `:v0.1.0`. This activates the behavior `v0.0.11` prepared for:
  - **Policy evaluation now runs.** Scanner `v0.1.0` parses `--disablePolicyEvaluation false` as false, so an image over your policy thresholds fails the step. Set `disable-policy-evaluation: 'true'` to keep the old report-only behavior.
  - A policy failure exits `3`, the only exit code that fails the step. Scanner errors, timeouts and bad credentials log `Continuing without failing build` and pass.
  - Debug output turns on with **Re-run jobs > Enable debug logging** (`RUNNER_DEBUG`) or `CDX_DEBUG` in `env:`, without editing `debug-mode`. The authorization token and git credentials are redacted from debug output.
  - Scanner logs stream live instead of appearing after the scan, and repository names no longer lose trailing characters (`acme/widget.git` was reported as `acme/widge`).
  - See [`Cloudanix/container-image-scanner`](https://github.com/Cloudanix/container-image-scanner) `v0.1.0`, PRs #33 and #34.
- Release notes now come from this changelog, and each release checks that the README's example `uses:` tag and Upgrading table match the version being released.
- Backfilled the `v0.0.10` and `v0.0.11` changelog sections and Upgrading rows, which those releases shipped without.

## v0.0.11

- **Policy evaluation now runs.** Every earlier release passed `--disablePolicyEvaluation false`, and [`Cloudanix/container-image-scanner`](https://github.com/Cloudanix/container-image-scanner) releases up to `v0.0.28` read any non-empty value as true, so policy was never evaluated. Once the `Dockerfile` pins a scanner release after `v0.0.28`, an image over your policy thresholds fails the step. Set `disable-policy-evaluation: 'true'` to keep the old report-only behavior.
- The step fails only on a policy failure (scanner exit code `3`). Any other scanner error becomes a `::warning::` annotation and the step passes. Requires a scanner pin that exits `3` on a policy failure; `v0.0.26` exits `1`, which this release would treat as a warning.
- `debug-mode` no longer defaults to `false`. `--debugMode true` is passed to the scanner only when `debug-mode` is `'true'`; otherwise the flag is omitted. Earlier releases always passed `--debugMode false`.
- Documented turning on debug output with **Re-run jobs > Enable debug logging** (`RUNNER_DEBUG`) or `CDX_DEBUG` in `env:`. Takes effect once the `Dockerfile` pins a scanner release that reads these variables ([`Cloudanix/container-image-scanner`](https://github.com/Cloudanix/container-image-scanner) branch `perf-fixes`); `v0.0.26` does not.
- Bumped the `Dockerfile`'s `FROM cloudanix/container-image-scanner` pin from `:v0.0.25` to `:v0.0.26`.
  - Scanner `v0.0.26` includes the image's registry when fetching policy evaluation limits. See [`Cloudanix/container-image-scanner`](https://github.com/Cloudanix/container-image-scanner) PR #30.

## v0.0.10

- Bumped the `Dockerfile`'s `FROM cloudanix/container-image-scanner` pin from `:v0.0.24` to `:v0.0.25`.
  - Scanner `v0.0.25` adds Bitbucket pipeline support and a further GitHub Actions git `safe.directory` fix so repo/commit metadata can be attached to scan results. See [`Cloudanix/container-image-scanner`](https://github.com/Cloudanix/container-image-scanner) PR #29.

## v0.0.9

- Fixed `action.yml`'s `args:` list passing each flag and its value as a single combined argv token (e.g. `"-a ${{ inputs.image }}"`) instead of two separate tokens. GitHub does not shell-split these — each list item becomes one literal argv entry to the container's `ENTRYPOINT` — so `entrypoint.sh`'s `getopts` was reading everything after the flag character, including the space, as part of the option's value. Every image reference this action ever scanned had a leading space, which fails image-reference parsing. This was already broken on `v0.0.8`, unrelated to the scanner pin below; it just happened to surface while validating that pin end-to-end.
- Pinned the `Dockerfile`'s `FROM cloudanix/container-image-scanner` to `:v0.0.24` (was unpinned, i.e. `:latest`).
  - Because this action builds its Docker image fresh on every workflow run, the previous unpinned `FROM` meant **every** workflow run picked up whatever was newest on Docker Hub at that moment, regardless of which action version/tag/SHA you had pinned in `uses:`. This release is the first one where the action tag you pin actually determines the scanner version you get.
  - `v0.0.24` fixes CI/CD context metadata (repository/organization/commit/`cicd`) that could be sent empty to the Cloudanix backend, plus a git "safe.directory" fix for containerized CI runners (relevant to this action, since GitHub Docker container actions run as a different user than the one that checked out the workspace). See [`Cloudanix/container-image-scanner`](https://github.com/Cloudanix/container-image-scanner) PR #28 and PR #27.
- Added this changelog and an "Upgrading" section to the README documenting which scanner version each action release pins.

## v0.0.8 and earlier

- See Git tags/releases for prior history. The scanner image was never pinned; the action always built against `cloudanix/container-image-scanner:latest`.
