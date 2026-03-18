# NixOS Config

This repo is organized around a small set of composable layers:

- Hosts in [`hosts/`](/home/gars/nixos-config/hosts)
- Shared NixOS modules in [`modules/system/`](/home/gars/nixos-config/modules/system)
- Shared Home Manager modules in [`modules/home/`](/home/gars/nixos-config/modules/home)
- Repo-local shared options in [`modules/shared/`](/home/gars/nixos-config/modules/shared)

`flake.nix` assembles those layers through descriptor attrsets for users, hosts, profiles, and outputs.

## Start Here

- Architecture: [`docs/architecture.md`](/home/gars/nixos-config/docs/architecture.md)
- Common workflows: [`docs/workflows.md`](/home/gars/nixos-config/docs/workflows.md)
- Current outputs and operational reference: [`docs/reference.md`](/home/gars/nixos-config/docs/reference.md)
- Host-local conventions: [`hosts/README.md`](/home/gars/nixos-config/hosts/README.md)
- Module conventions: [`modules/README.md`](/home/gars/nixos-config/modules/README.md)

## Current Outputs

| Output | Purpose |
| --- | --- |
| `boreal-tty` | Minimal TTY profile on the boreal host |
| `boreal-tty-cyberdeck` | TTY profile plus cyberdeck-specific CLI tooling |
| `boreal` | Main Sway desktop |
| `boreal-gaming` | Sway desktop plus Steam |
| `boreal-gamescope` | Minimal Steam + gamescope session |
| `boreal-niri` | Niri desktop |
| `boreal-hypr` | Hyprland desktop |
| `nixos-vm` | Minimal VM profile |

## Common Commands

- `sudo nixos-rebuild switch --flake .#boreal`
- `sudo nixos-rebuild switch --flake .#boreal-gaming`
- `sudo nixos-rebuild switch --flake .#boreal-gamescope`
- `sudo nixos-rebuild switch --flake .#boreal-niri`
- `sudo nixos-rebuild switch --flake .#boreal-hypr`
- `sudo nixos-rebuild switch --flake .#boreal-tty`
- `sudo nixos-rebuild switch --flake .#boreal-tty-cyberdeck`
- `sudo nixos-rebuild switch --flake .#nixos-vm`
- `rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra`
