#!/bin/bash
set -e
disablePolicyEvaluation="false"
debugMode="false"
if [ -d /github/workspace ] && [ ! -e /workspace ]; then
  ln -s /github/workspace /workspace
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
      export debugMode="${OPTARG:-"false"}"
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
  --debugMode "$debugMode"
)

normalizedDisable="$(printf '%s' "$disablePolicyEvaluation" | tr '[:upper:]' '[:lower:]')"
case "$normalizedDisable" in
  1|true|yes|y|on)
    cmd+=(--disablePolicyEvaluation true)
    ;;
esac

set +e
"${cmd[@]}"
returnCode="$?"
exit "$returnCode"
