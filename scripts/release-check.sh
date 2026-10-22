#!/bin/bash
# The top "## vX.Y.Z" heading in CHANGELOG.md is the version the release
# workflow tags. This checks README.md and the Dockerfile agree with it, so
# customers never read docs that lag the release.
# Usage: scripts/release-check.sh        -> validates, prints the version
#        scripts/release-check.sh notes  -> prints that version's changelog section
set -euo pipefail
cd "$(dirname "$0")/.." || exit 1

fail() {
  echo "::error::$*" >&2
  exit 1
}

heading=$(grep -m1 '^## ' CHANGELOG.md || true)
version=$(sed -nE 's/^## (v[0-9]+\.[0-9]+\.[0-9]+)( .*)?$/\1/p' <<<"$heading")
[ -n "$version" ] || fail "CHANGELOG.md: top heading '$heading' must be '## vX.Y.Z'. Rename '## Unreleased' to the next version before merging to main."

if [ "${1:-}" = notes ]; then
  awk -v h="$heading" '$0 == h { on = 1; next } on && /^## / { exit } on' CHANGELOG.md
  exit 0
fi

escaped=${version//./\\.}
grep -qE "cloudanix-image-scanner-github-action@${escaped}\$" README.md ||
  fail "README.md: 'Example usage' must use cloudanix-image-scanner-github-action@$version"

scanner=$(sed -nE 's/^FROM cloudanix\/container-image-scanner:(.+)$/\1/p' Dockerfile)
grep -qF "| \`$version\` | \`$scanner\` |" README.md ||
  fail "README.md: 'Upgrading' table needs a row starting '| \`$version\` | \`$scanner\` |' (scanner pin from Dockerfile)"

echo "$version"
