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

image-scanner $type $imageRef --no-progress --db-repository "ghcr.io/aquasecurity/trivy-db,docker.io/aquasec/trivy-db" --java-db-repository "ghcr.io/aquasecurity/trivy-java-db,docker.io/aquasec/trivy-java-db" --format $format --scanners $scanType --api-endpoint $apiEndpoint --authz-token $authZToken --identifier $identifier

returnCode=$?

exit $returnCode
