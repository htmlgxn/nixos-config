# NixOS Config

This repo is organized around three layers:

- Hosts: machine-specific hardware, storage, networking, and service values under `hosts/`
- System profiles: NixOS module sets for TTY, desktop compositors, gaming, and services under `modules/system/`
- Home profiles: Home Manager module sets for shared CLI, desktop packages, dotfiles, and user tools under `modules/home/`

`flake.nix` composes those layers from descriptor attrsets instead of hardcoded helper calls per output.

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

## Structure

### Hosts

- `hosts/boreal/configuration.nix` is now a thin import list.
- `hosts/boreal/base.nix` contains boot, locale, and Nix defaults.
- `hosts/boreal/graphics.nix` contains AMD and graphics-related settings.
- `hosts/boreal/storage.nix` contains filesystems, swap, zram, and mountpoint tmpfiles rules.
- `hosts/boreal/networking.nix` contains host naming, NetworkManager, and firewall.
- `hosts/boreal/users.nix` contains local users and the primary-user setting.
- `hosts/boreal/services.nix` contains host-specific service values such as Jellyfin storage paths.

### Shared Local Options

`modules/shared/my-options.nix` defines the repo-local `my.*` namespace used to avoid hardcoded values:

- `my.primaryUser`
- `my.repoRoot`
- `my.dotfilesRoot`
- `my.jellyfin.*`

### System Modules

- `modules/system/cli.nix`: shared TTY/system baseline
- `modules/system/gui-base.nix`: shared desktop base for full GUI profiles
- `modules/system/sway.nix`, `modules/system/niri.nix`, `modules/system/hyprland.nix`: compositor-specific system layers
- `modules/system/gaming.nix`: Steam and gaming support
- `modules/system/gamescope.nix`: minimal Steam + gamescope session
- `modules/system/jellyfin.nix`: generic Jellyfin module driven by `my.jellyfin.*`

### Home Modules

- `modules/home/cli.nix`: shared CLI packages
- `modules/home/cli-extras.nix`: extra user-specific CLI packages
- `modules/home/cli-cyberdeck.nix`: cyberdeck test/device CLI additions
- `modules/home/gui-base.nix`: shared desktop packages
- `modules/home/sway.nix`, `modules/home/niri.nix`, `modules/home/hyprland.nix`: compositor-specific Home Manager config
- `modules/home/gaming.nix`: lightweight gaming additions usable by both desktop and gamescope profiles
- `modules/home/users/gars.nix`: user entrypoint for `gars`

## Common Changes

### Add CLI packages

- Shared for all users: `modules/home/cli.nix`
- Extra user-specific packages: `modules/home/cli-extras.nix`
- Device/profile-specific CLI packages: `modules/home/cli-cyberdeck.nix`

### Add desktop packages

- Shared across desktop profiles: `modules/home/gui-base.nix`
- Compositor-specific: `modules/home/sway.nix`, `modules/home/niri.nix`, `modules/home/hyprland.nix`

### Add system packages or services

- Shared system baseline: `modules/system/cli.nix`
- Profile-specific system behavior: the relevant file in `modules/system/`
- Host-only values or storage details: a module under `hosts/<name>/`

### Add a new user

1. Create `modules/home/users/<username>.nix`.
2. Register the user in the `users` attrset in `flake.nix`.
3. Add any optional extra home modules for that user.
4. Reference the user from one or more `outputDefs` entries.

### Add a new host

1. Create `hosts/<hostname>/configuration.nix`.
2. Split host-local concerns into additional files if the host is non-trivial.
3. Register the host in the `hosts` attrset in `flake.nix`.
4. Add one or more `outputDefs` entries for that host.

### Add a new profile

1. Add the relevant module list to `homeProfiles` and/or `systemProfiles` in `flake.nix`.
2. Add an `outputDefs` entry that pairs a host, user, system profile, and home profile.

## Operator Commands

- `sudo nixos-rebuild switch --flake .#boreal`
- `sudo nixos-rebuild switch --flake .#boreal-gaming`
- `sudo nixos-rebuild switch --flake .#boreal-gamescope`
- `sudo nixos-rebuild switch --flake .#boreal-niri`
- `sudo nixos-rebuild switch --flake .#boreal-hypr`
- `sudo nixos-rebuild switch --flake .#boreal-tty`
- `sudo nixos-rebuild switch --flake .#boreal-tty-cyberdeck`
- `sudo nixos-rebuild switch --flake .#nixos-vm`
- `rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra`
