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
- Host-local conventions: [`hosts/README.md`](hosts/README.md)
- Shared module conventions: [`modules/README.md`](modules/README.md)

## Current Outputs

| Output | Type | Purpose |
| --- | --- | --- |
| `boreal-tty` | NixOS | Minimal TTY profile on the boreal host with AI CLI overlays |
| `boreal-tty-cyberdeck` | NixOS | TTY profile plus cyberdeck CLI additions and AI CLI overlays |
| `boreal` | NixOS | Main Sway desktop with Boreal desktop overlays |
| `boreal-gaming` | NixOS | Sway desktop plus Steam and Boreal desktop overlays |
| `boreal-gamescope` | NixOS | Minimal Steam + gamescope session |
| `boreal-niri` | NixOS | Niri desktop with Boreal GUI overlays |
| `boreal-hypr` | NixOS | Hyprland desktop with Boreal GUI overlays |
| `nixos-vm` | NixOS | Minimal VM profile |
| `cyberdeck-tty` | NixOS | Jetson cyberdeck TTY profile |
| `rpi4-tty` | NixOS | Raspberry Pi 4 TTY profile |
| `rpi4-sway` | NixOS | Raspberry Pi 4 Sway profile (lean ARM variant) |
| `rpi4-sway-full` | NixOS | Raspberry Pi 4 Sway with heavier desktop extras |
| `rpi4-tty-cyberdeck` | NixOS | Raspberry Pi 4 TTY profile plus cyberdeck CLI additions |
| `macbook` | nix-darwin | Apple Silicon nix-darwin host with AI CLI overlay |
| `fedora-arm` | Home Manager | Standalone Home Manager profile for Fedora ARM |

## Common Commands

- `nr <output>`
- `nrb <output>`
- `ns [query]`
- `darwin-rebuild switch --flake .#macbook`
- `home-manager switch --flake .#fedora-arm`
- `rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra`

See [`docs/reference.md`](docs/reference.md) for the exact output matrix and [`docs/workflows.md`](docs/workflows.md) for how to add or change composition pieces safely.
