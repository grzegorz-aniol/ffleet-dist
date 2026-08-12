# Forge Fleet

<p align="center">
  <img src="https://ffleet.app/assets/forge-fleet-splash-1.png" alt="Forge Fleet" width="640">
</p>

Forge a fleet of AI coding agents. Each sealed in its own container. Local-first,
free for everyone — no cloud VMs, no agent with a shell on your host.

This is the public distribution repo for [Forge Fleet](https://ffleet.app/). It
builds and publishes the Forge Fleet agent container images to the GitHub
Container Registry (GHCR).

📖 **Documentation:** see the [Forge Fleet wiki](https://github.com/grzegorz-aniol/ffleet-dist/wiki).

## Published images

- `ghcr.io/grzegorz-aniol/forge-fleet-python:latest` — base agent image
  (Python/uv + Node/TypeScript + agent toolbox).
- `ghcr.io/grzegorz-aniol/forge-fleet-go:latest` — Go-dev variant (base toolbox
  + Go toolchain).

The image Dockerfiles and the `publish-images` GitHub Actions workflow that
builds and pushes them live in this repo.

Learn more at https://ffleet.app/.

## License

© 2026 AppGA. Proprietary freeware — licensed, not sold. See [LICENSE.txt](LICENSE.txt).
