# ffleet-dist

Public distribution repo for [Forge Fleet](https://ffleet.app/). It builds and
publishes the Forge Fleet agent container images to the GitHub Container
Registry (GHCR).

## Published images

- `ghcr.io/grzegorz-aniol/forge-fleet-python:latest` — base agent image
  (Python/uv + Node/TypeScript + agent toolbox).
- `ghcr.io/grzegorz-aniol/forge-fleet-go:latest` — Go-dev variant (base toolbox
  + Go toolchain).

The image Dockerfiles and the `publish-images` GitHub Actions workflow that
builds and pushes them live in this repo.

Learn more at https://ffleet.app/.
