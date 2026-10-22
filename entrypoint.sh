#!/bin/bash
# Only a policy failure fails the step. Anything else that goes wrong is a
# Cloudanix-side problem and must never fail the customer's build, so there is
# deliberately no `set -e`.
POLICY_FAILURE_EXIT_CODE=3
disablePolicyEvaluation="false"
debugMode="false"

if [ -d /github/workspace ] && [ ! -e /workspace ]; then
  ln -s /github/workspace /workspace || echo "::warning::Could not link /workspace to /github/workspace"
fi

while getopts "a:b:c:d:e:" o; do
  case "${o}" in
    a)
      export imageRef="${OPTARG}"
    ;;
    b)
      export authZToken="${OPTARG}"
    ;;
    c)
      export identifier="${OPTARG}"
    ;;
    d)
      export disablePolicyEvaluation="${OPTARG}"
    ;;
    e)
      export debugMode="${OPTARG}"
    ;;
    *)
      echo "invalid param"
    ;;
  esac
done

cmd=(
  imagescanner
  --imageToScan "$imageRef"
  --authZToken "$authZToken"
  --identifier "$identifier"
)

# Boolean flags are passed only when enabled: older scanners read any
# non-empty value, including "false", as true.
is_true() {
  case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" in
    1|true|yes|y|on) return 0 ;;
  esac
  return 1
}

is_true "$disablePolicyEvaluation" && cmd+=(--disablePolicyEvaluation true)
is_true "$debugMode" && cmd+=(--debugMode true)

returnCode=0
"${cmd[@]}" || returnCode=$?

if [ "$returnCode" -eq "$POLICY_FAILURE_EXIT_CODE" ]; then
  exit "$returnCode"
fi
if [ "$returnCode" -ne 0 ]; then
  echo "::warning::Cloudanix image scan failed with exit code $returnCode. Continuing without failing the build"
fi
exit 0
