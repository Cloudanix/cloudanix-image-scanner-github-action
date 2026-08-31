# Changelog

## v0.0.9

- Fixed `action.yml`'s `args:` list passing each flag and its value as a single combined argv token (e.g. `"-a ${{ inputs.image }}"`) instead of two separate tokens. GitHub does not shell-split these — each list item becomes one literal argv entry to the container's `ENTRYPOINT` — so `entrypoint.sh`'s `getopts` was reading everything after the flag character, including the space, as part of the option's value. Every image reference this action ever scanned had a leading space, which fails image-reference parsing. This was already broken on `v0.0.8`, unrelated to the scanner pin below; it just happened to surface while validating that pin end-to-end.
- Pinned the `Dockerfile`'s `FROM cloudanix/container-image-scanner` to `:v0.0.25` (was unpinned, i.e. `:latest`).
  - Because this action builds its Docker image fresh on every workflow run, the previous unpinned `FROM` meant **every** workflow run picked up whatever was newest on Docker Hub at that moment, regardless of which action version/tag/SHA you had pinned in `uses:`. This release is the first one where the action tag you pin actually determines the scanner version you get.
  - `v0.0.25` fixes CI/CD context metadata (repository/organization/commit/`cicd`) that could be sent empty to the Cloudanix backend, plus a git "safe.directory" fix for containerized CI runners (relevant to this action, since GitHub Docker container actions run as a different user than the one that checked out the workspace). See [`Cloudanix/container-image-scanner`](https://github.com/Cloudanix/container-image-scanner) PR #28 and PR #27.
- Added this changelog and an "Upgrading" section to the README documenting which scanner version each action release pins.

## v0.0.8 and earlier

- See Git tags/releases for prior history. The scanner image was never pinned; the action always built against `cloudanix/container-image-scanner:latest`.
