#!/bin/bash
set -e
while getopts "a:b:c:d:" o; do
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
      export debugMode="${OPTARG:-"false"}"
    ;;
  esac
done

echo "imageRef - $imageRef"
echo "authZToken - $authZToken"
echo "identifier - $identifier"
echo "debugMode - $debugMode"

export debugMode="${debugMode:-"false"}"
echo "debugMode - $debugMode"

imagescanner --imageToScan $imageRef --authZToken $authZToken --identifier $identifier --debugMode $debugMode

returnCode=$?

exit $returnCode
