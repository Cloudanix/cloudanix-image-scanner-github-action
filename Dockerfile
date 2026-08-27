# Container image that scans code
#
# Pinned to a specific version rather than the implicit ":latest" tag. GitHub
# builds this Dockerfile fresh on every workflow run, so an unpinned FROM
# meant every action version -- even ones pinned by tag/SHA -- silently
# picked up whatever was newest on Docker Hub at run time. Bumping this tag
# is now the only way the underlying scanner version changes.
FROM cloudanix/container-image-scanner:v0.0.24

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN apk --no-cache add bash curl npm
RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
