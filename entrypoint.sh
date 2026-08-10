#!/bin/bash
set -e
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

imagescanner --imageToScan "$imageRef" --authZToken "$authZToken" --identifier "$identifier" --disablePolicyEvaluation "$disablePolicyEvaluation" --debugMode "$debugMode"

returnCode="$?"

exit "$returnCode"
