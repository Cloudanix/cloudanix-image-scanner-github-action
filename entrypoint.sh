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
      export debugMode="${OPTARG-"false"}"
    ;;
  esac
done

imagescanner --imageToScan $imageRef --authZToken $authZToken --identifier $identifier --debugMode $debugMode

returnCode=$?

exit $returnCode
