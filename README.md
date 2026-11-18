# Nix Config

This repo is built around a modular assembly model: each final output should be composed from the smallest useful set of reusable pieces, with heavyweight features added explicitly instead of arriving through hidden coupling.

The main layers are:

- hosts in [`hosts/`](hosts)
- shared NixOS modules in [`modules/system/`](modules/system)
- shared Home Manager modules in [`modules/home/`](modules/home)
- repo-local shared options in [`modules/shared/`](modules/shared)

`flake.nix` is only the input manifest plus a list of `parts/` modules. [`parts/inventory.nix`](parts/inventory.nix) holds the descriptor attrsets for users, hosts, home profiles, system profiles, and explicit home-module overlay groups; [`parts/lib.nix`](parts/lib.nix) holds the builders; `parts/nixos.nix`, `parts/darwin.nix`, and `parts/home.nix` select the outputs. Final outputs are then mapped into `nixosConfigurations`, `darwinConfigurations`, and `homeConfigurations`.

## Start Here

- Architecture and composition rules: [`docs/architecture.md`](docs/architecture.md)
- Common change workflows: [`docs/workflows.md`](docs/workflows.md)
- Current outputs, overlays, and service reference: [`docs/reference.md`](docs/reference.md)
- Nix helper cheat sheet and deployment workflows: [`docs/nix-workflows.md`](docs/nix-workflows.md)
- Host-local conventions: [`hosts/README.md`](hosts/README.md)
- Shared module conventions: [`modules/README.md`](modules/README.md)

## Current Outputs

| Output       | Type         | Purpose                                              |
| ------------ | ------------ | ---------------------------------------------------- |
| `boreal-tty` | NixOS        | CLI/server profile on boreal with AI CLI overlays    |
| `boreal`     | NixOS        | Full Sway desktop with gaming and AI CLI             |
| `jtop`       | NixOS        | Janine's laptop: simple COSMIC desktop               |
| `nixos-vm`   | NixOS        | Minimal VM profile                                   |
| `rpi4-tty`   | NixOS        | Raspberry Pi 4 TTY profile                           |
| `rpi4-sway`  | NixOS        | Raspberry Pi 4 Sway profile (lean ARM variant)       |
| `macbook`    | nix-darwin   | Apple Silicon nix-darwin host with AI CLI overlay    |
| `fedora-mac` | Home Manager | Standalone Home Manager profile for Fedora on ARM    |
| `jetson`     | Home Manager | Standalone Home Manager profile for Jetson Orin Nano |

## Standalone Home Manager Hosts

The standalone HM hosts (`fedora-mac`, `jetson`) run on non-NixOS systems where the nix daemon is managed by the host OS. These hosts need manual `/etc/nix/nix.conf` configuration for binary caches — see [`docs/sway-hm-prerequisites.md`](docs/sway-hm-prerequisites.md#nix-cache-configuration) for the required substituters and trusted public keys.

## Common Commands

- `nr <output>`
- `nrb <output>`
- `ns [query]`
- `ndrs` (macbook)
- `nhms` (fedora-mac)
- `nix fmt` (treefmt: alejandra, deadnix, statix, stylua, shfmt, prettier)
- `nix develop` (formatter, nixd, nh, nvd, nix-output-monitor without installing them)

See [`docs/nix-workflows.md`](docs/nix-workflows.md) for the full helper surface, [`docs/reference.md`](docs/reference.md) for the exact output matrix, and [`docs/workflows.md`](docs/workflows.md) for how to add or change composition pieces safely.
