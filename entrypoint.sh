#!/bin/bash
set -e
while getopts "a:b:c:d:e" o; do
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
      export enablePolicyEvaluation="${OPTARG}"
    ;;
    e)
      export debugMode="${OPTARG:-"false"}"
    ;;
    *)
      echo "invalid param"
    ;;
  esac
done

imagescanner --imageToScan "$imageRef" --authZToken "$authZToken" --identifier "$identifier" --enablePolicyEvaluation "$enablePolicyEvaluation" --debugMode "$debugMode"

returnCode="$?"

exit "$returnCode"
