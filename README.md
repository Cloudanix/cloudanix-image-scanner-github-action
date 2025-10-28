# Cloudanix Image Vulnerability Scanner

This Github Action from Cloudanix scans your docker images for Vulnerabilities with Policy based evaluation.

## Inputs

## `image`

**Required** Docker Image to be scanned

## `authz-token`

**Required** API Authorization Token

## `identifier`

**Required** Unique Identifier

## `enable-policy-evaluation`

**Optional** Enable Policy Evaluation. Defaults to true.

## `debug-mode`

**Optional** Enable Debug Mode. Defaults to false.

## Outputs

## `vulnerabilities`

The vulnerabilities of the Docker Image.

## Example usage

```yml
- name: Run Cloudanix Image Vulnerability Scanner
  uses: cloudanix/cloudanix-image-scanner-github-action@v0.0.7
  with:
    image: 'ubuntu:24.10'
    authz-token: '${{ secrets.CDX_AUTHZ_TOKEN }}'
    identifier: '${{ secrets.CDX_ACCOUNT_IDENTIFIER }}'
```
