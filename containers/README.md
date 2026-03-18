# Containers

This repo uses a Podman-first container workspace for local service experiments.

## Layout

- `quadlet/`: systemd Quadlet files for longer-running Podman services
- `compose/`: compose-style projects that run with `podman compose`
- `npm/`: npm-based applications that are run directly with Node instead of a container runtime

## Defaults

- Runtime: Podman
- OCI backend: Podman
- Docker compatibility: off unless a specific project actually requires it
- Node apps: run directly with the `nodejs` package from Home Manager

## Shell Helpers

- `cdcont`
- `cdquad`
- `cdcomp`
- `cdnpmapp`
- `pc`
