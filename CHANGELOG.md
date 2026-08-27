# Changelog

## v0.0.9

- Pinned the `Dockerfile`'s `FROM cloudanix/container-image-scanner` to `:v0.0.24` (was unpinned, i.e. `:latest`).
  - Because this action builds its Docker image fresh on every workflow run, the previous unpinned `FROM` meant **every** workflow run picked up whatever was newest on Docker Hub at that moment, regardless of which action version/tag/SHA you had pinned in `uses:`. This release is the first one where the action tag you pin actually determines the scanner version you get.
  - `v0.0.24` fixes CI/CD context metadata (repository/organization/commit/`cicd`) that could be sent empty to the Cloudanix backend, plus a git "safe.directory" fix for containerized CI runners (relevant to this action, since GitHub Docker container actions run as a different user than the one that checked out the workspace). See [`Cloudanix/container-image-scanner`](https://github.com/Cloudanix/container-image-scanner) PR #28 and PR #27.
- Added this changelog and an "Upgrading" section to the README documenting which scanner version each action release pins.

## v0.0.8 and earlier

- See Git tags/releases for prior history. The scanner image was never pinned; the action always built against `cloudanix/container-image-scanner:latest`.
