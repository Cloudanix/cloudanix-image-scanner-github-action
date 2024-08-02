# Image Scanner action

This Github Action from Cloudanix scans your docker images for Vulnerabilities.

## Inputs

## `image`

**Required** Docker Image to be scanned

## `api-endpoint`

**Required** API Endpoint to push findings

## `authz-token`

**Required** API Authorization Token

## `identifier`

**Required** Unique Identifier

## Outputs

## `vulnerabilities`

The vulnerabilities of the Docker Image.

## Example usage

uses: cloudanix/image-scanner@master
with:
  image: "ubuntu:24.10"
  api-endpoint: "https://api.api.com"
  authz-token: "token-12345"
  identifier: "identifier-12345"
