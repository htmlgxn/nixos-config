# Nix Config

This repo is organized around a small set of composable layers:

- Hosts in [`hosts/`](hosts)
- Shared NixOS modules in [`modules/system/`](modules/system)
- Shared Home Manager modules in [`modules/home/`](modules/home)
- Repo-local shared options in [`modules/shared/`](modules/shared)

`flake.nix` assembles those layers through descriptor attrsets for users, hosts, and profiles, then maps them into three output types: `nixosConfigurations`, `darwinConfigurations`, and `homeConfigurations`.

## Start Here

- Architecture: [`docs/architecture.md`](docs/architecture.md)
- Common workflows: [`docs/workflows.md`](docs/workflows.md)
- Current outputs and operational reference: [`docs/reference.md`](docs/reference.md)
- Host-local conventions: [`hosts/README.md`](hosts/README.md)
- Module conventions: [`modules/README.md`](modules/README.md)

## Current Outputs

| Output | Type | Purpose |
| --- | --- | --- |
| `boreal-tty` | NixOS | Minimal TTY profile on the boreal host |
| `boreal-tty-cyberdeck` | NixOS | TTY profile plus cyberdeck-specific CLI tooling |
| `boreal` | NixOS | Main Sway desktop |
| `boreal-gaming` | NixOS | Sway desktop plus Steam |
| `boreal-gamescope` | NixOS | Minimal Steam + gamescope session |
| `boreal-niri` | NixOS | Niri desktop |
| `boreal-hypr` | NixOS | Hyprland desktop |
| `nixos-vm` | NixOS | Minimal VM profile |
| `cyberdeck-tty` | NixOS | Jetson cyberdeck TTY profile |
| `rpi4-tty` | NixOS | Raspberry Pi 4 TTY profile |
| `rpi4-sway` | NixOS | Raspberry Pi 4 Sway profile (no Flatpak) |
| `rpi4-sway-full` | NixOS | Raspberry Pi 4 Sway with full home profile |
| `rpi4-tty-cyberdeck` | NixOS | Raspberry Pi 4 TTY profile plus cyberdeck CLI additions |
| `macbook` | nix-darwin | Apple Silicon nix-darwin host with Home Manager |
| `fedora-arm` | Home Manager | Standalone Home Manager profile for Fedora ARM |

## Common Commands

- `nr boreal`
- `nr boreal-gaming`
- `nr boreal-gamescope`
- `nr boreal-niri`
- `nr boreal-hypr`
- `nr boreal-tty`
- `nr boreal-tty-cyberdeck`
- `nr nixos-vm`
- `nr cyberdeck-tty`
- `nr rpi4-tty`
- `nr rpi4-sway`
- `nr rpi4-sway-full`
- `nr rpi4-tty-cyberdeck`
- `nrb <output>` builds an output without switching
- `ns [query]` searches Nix packages/options with `nix-search-tv` through `fzf`
- `darwin-rebuild switch --flake .#macbook`
- `home-manager switch --flake .#fedora-arm`
- `rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra`
