#!/bin/bash
set -e
while getopts "a:b:c:d:e:f:g:h:i:" o; do
  case "${o}" in
    a)
      export type="${OPTARG-"image"}"
    ;;
    b)
      export imageRef="${OPTARG}"
    ;;
    c)
      export format="${OPTARG-"json"}"
    ;;
    d)
      export scanType="${OPTARG-"vuln"}"
    ;;
    e)
      export timeout="${OPTARG}"
    ;;
    f)
      export apiEndpoint="${OPTARG}"
    ;;
    g)
      export authZToken="${OPTARG}"
    ;;
    h)
      export identifier="${OPTARG}"
    ;;
  esac
done

image-scanner $type $imageRef --format $format --scanners $scanType --api-endpoint $apiEndpoint --authz-token $authZToken --identifier $identifier

returnCode=$?

exit $returnCode
