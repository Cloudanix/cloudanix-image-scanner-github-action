# Cloudanix Image Vulnerability Scanner

This Github Action from Cloudanix scans your docker images for Vulnerabilities with Policy based evaluation.

## Inputs

## `image`

**Required** Docker Image to be scanned

## `authz-token`

**Required** API Authorization Token

## `identifier`

**Required** Unique Identifier

## `disable-policy-evaluation`

**Optional** Disable Policy Evaluation. Defaults to false. Set `'true'` to report findings without failing the step. Releases before the one that pins a scanner with the boolean-flag fix never evaluated policy; see the [changelog](CHANGELOG.md).

## `debug-mode`

**Optional** Enable Debug Mode. Omitted by default; set `'true'` to pass `--debugMode true` to the scanner. Any other value leaves the flag off.

You can also get debug output without editing the workflow: on a failed or finished run, choose **Re-run jobs > Enable debug logging**. GitHub sets `RUNNER_DEBUG=1` for that run and passes it into this action's container, and the scanner turns on debug output. Setting `CDX_DEBUG: 'true'` in the step's or job's `env:` also works. Needs an action release whose scanner pin reads these variables; see [Upgrading](#upgrading).

Debug output never includes the authorization token.

## When the step fails

Only a policy failure (the image exceeds your policy thresholds) fails the step. If the scan cannot run, for example because of a configuration, network or scanner error, the step logs a warning annotation, `Cloudanix image scan failed with exit code N. Continuing without failing the build`, and passes. This needs an action release whose scanner pin exits `3` on a policy failure; see [Upgrading](#upgrading).

GitHub builds this action's Docker image before the step runs. If that build fails, for example because Docker Hub is unreachable, the step fails before the scanner starts. Add `continue-on-error: true` to the step if that must not fail your job.

## Outputs

## `vulnerabilities`

The vulnerabilities of the Docker Image.

## Example usage

```yml
- name: Run Cloudanix Image Vulnerability Scanner
  uses: cloudanix/cloudanix-image-scanner-github-action@v0.0.9
  with:
    image: 'ubuntu:24.10'
    authz-token: '${{ secrets.CDX_AUTHZ_TOKEN }}'
    identifier: '${{ secrets.CDX_ACCOUNT_IDENTIFIER }}'
```

> **Pin to a specific released tag, not `@main`.** This action's `Dockerfile` is built fresh on every workflow run, and it pins the underlying `cloudanix/container-image-scanner` image it's built from. Each release of this action can bump that pin. Pinning your `uses:` to an explicit tag means you only pick up a new scanner version when you deliberately bump that tag; see [Upgrading](#upgrading) below.

## Upgrading

| Action version | Base `cloudanix/container-image-scanner` | Notes |
| --- | --- | --- |
| Unreleased | `v0.0.25` | Bumps the pin from `v0.0.24`. Adds Bitbucket pipeline support and a further GitHub Actions git `safe.directory` fix; see the scanner's changelog for details. |
| `v0.0.9` | `v0.0.24` | First pinned scanner version. Fixes CI/CD context metadata (repository/organization/commit) that could be sent empty; see the scanner's changelog for details. |
| `v0.0.8` and earlier | unpinned (`:latest`) | Moving target — every workflow run rebuilt this Dockerfile against whatever was newest on Docker Hub, regardless of which action tag you had pinned. |

To move to a new scanner version, bump your `uses: cloudanix/cloudanix-image-scanner-github-action@<tag>` to the new tag once you've reviewed the corresponding release notes. Workflows still pinned to `v0.0.8` or earlier, or to `@main`, are unaffected until you make that change.
