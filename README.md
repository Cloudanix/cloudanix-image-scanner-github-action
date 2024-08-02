# Cloudanix Image Vulnerability Scanner

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

```yml
- name: Run Cloudanix Image Vulnerability Scanner
  uses: cloudanix/cloudanix-image-scanner-github-action@v0.0.2
  with:
    image: 'ubuntu:24.10'
    api-endpoint: '${{ secrets.CDX_API_ENDPOINT }}'
    authz-token: '${{ secrets.CDX_AUTHZ_TOKEN }}'
    identifier: '${{ secrets.CDX_ACCOUNT_IDENTIFIER }}'
```
