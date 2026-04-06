# Nix Config

This repo is built around a modular assembly model: each final output should be composed from the smallest useful set of reusable pieces, with heavyweight features added explicitly instead of arriving through hidden coupling.

The main layers are:

- hosts in [`hosts/`](hosts)
- shared NixOS modules in [`modules/system/`](modules/system)
- shared Home Manager modules in [`modules/home/`](modules/home)
- repo-local shared options in [`modules/shared/`](modules/shared)

`flake.nix` assembles those layers through descriptor attrsets for users, hosts, home profiles, system profiles, and explicit home-module overlay groups. Final outputs are then mapped into `nixosConfigurations`, `darwinConfigurations`, and `homeConfigurations`.

## Start Here

- Architecture and composition rules: [`docs/architecture.md`](docs/architecture.md)
- Common change workflows: [`docs/workflows.md`](docs/workflows.md)
- Current outputs, overlays, and service reference: [`docs/reference.md`](docs/reference.md)
- Nix helper cheat sheet and deployment workflows: [`docs/nix-workflows.md`](docs/nix-workflows.md)
- Host-local conventions: [`hosts/README.md`](hosts/README.md)
- Shared module conventions: [`modules/README.md`](modules/README.md)

## Current Outputs

| Output | Type | Purpose |
| --- | --- | --- |
| `boreal-tty` | NixOS | CLI/server profile on boreal with AI CLI overlays |
| `boreal` | NixOS | Full Sway desktop with gaming, Boreal desktop overlays |
| `nixos-vm` | NixOS | Minimal VM profile |
| `rpi4-tty` | NixOS | Raspberry Pi 4 TTY profile |
| `rpi4-sway` | NixOS | Raspberry Pi 4 Sway profile (lean ARM variant) |
| `macbook` | nix-darwin | Apple Silicon nix-darwin host with AI CLI overlay |
| `fedora-arm` | Home Manager | Standalone Home Manager profile for Fedora ARM |

## Common Commands

- `nr <output>`
- `nrb <output>`
- `ns [query]`
- `darwin-rebuild switch --flake .#macbook`
- `home-manager switch --flake .#fedora-arm`
- `rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra`

See [`docs/nix-workflows.md`](docs/nix-workflows.md) for the full helper surface, [`docs/reference.md`](docs/reference.md) for the exact output matrix, and [`docs/workflows.md`](docs/workflows.md) for how to add or change composition pieces safely.
