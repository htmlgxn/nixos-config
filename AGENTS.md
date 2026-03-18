# Repository Guidelines

## Project Structure & Module Organization
- Canonical operator docs now live in `README.md`, `docs/architecture.md`, `docs/workflows.md`, `docs/reference.md`, `hosts/README.md`, and `modules/README.md`.
- `flake.nix` defines all NixOS and Home Manager outputs through descriptor attrsets for `users`, `hosts`, `homeProfiles`, `systemProfiles`, and `outputDefs`. Current NixOS outputs are `boreal-tty`, `boreal-tty-cyberdeck`, `boreal`, `boreal-gaming`, `boreal-gamescope`, `boreal-niri`, `boreal-hypr`, and `nixos-vm`.
- `hosts/<name>/configuration.nix` contains per-host system settings.
- `hosts/<name>/hardware-configuration.nix` is generated; do not edit it manually or via automation.
- `hosts/boreal/configuration.nix` is now a thin import list; the boreal host is split into `base.nix`, `graphics.nix`, `storage.nix`, `networking.nix`, `users.nix`, and `services.nix`. `hosts/cyberdeck/configuration.nix` is the aarch64 Jetson target. `hosts/nixos-vm/configuration.nix` is the VM profile.
- `modules/shared/my-options.nix` defines the repo-local `my.*` namespace used for values like `my.repoRoot`, `my.dotfilesRoot`, `my.primaryUser`, and `my.jellyfin.*`.
- `modules/system/cli.nix` provides the shared TTY/system baseline. `modules/system/gui-base.nix` is shared by the compositor modules.
- `modules/system/sway.nix`, `modules/system/niri.nix`, and `modules/system/hyprland.nix` extend the GUI base with compositor-specific system services and packages.
- `modules/system/gamescope.nix` defines the minimal Steam + gamescope session profile and intentionally skips the shared GUI base.
- `modules/system/gaming.nix` adds system-level gaming support such as Steam and Proton compatibility packages.
- `modules/system/jellyfin.nix` is now driven by `my.jellyfin.*` values supplied by the host layer instead of hardcoding boreal paths.
- `modules/system/flatpak.nix` enables the system-level Flatpak stack; `modules/home/flatpak.nix` handles the user-level remote + installs.
- `modules/home/cli.nix`, `modules/home/gui-base.nix`, `modules/home/sway.nix`, `modules/home/niri.nix`, `modules/home/hyprland.nix`, and `modules/home/gaming.nix` define shared Home Manager layers.
- `modules/home/users/<name>.nix` is the per-user Home Manager entrypoint; `modules/home/users/gars.nix` is the current user module.
- `modules/home/flatpak/packages.nix` and `modules/home/packages/{go,python,rust}` maintain curated package sets imported by the shared Home Manager stack.
- `home/gars/dots/` and `home/gars/nvim/` contain dotfiles and editor configuration referenced by Home Manager modules.

## Build, Test, and Development Commands
- These commands are for the human operator only. Agents must not run rebuilds or switch operations.
- `nr <output>` switches to a named output; supported values are `boreal`, `boreal-gaming`, `boreal-gamescope`, `boreal-niri`, `boreal-hypr`, `boreal-tty`, `boreal-tty-cyberdeck`, and `nixos-vm`.
- `nrb <output>` builds a named output without switching.
- `nrs` and `nrtty` remain as permanent shortcuts for `boreal` and `boreal-tty`.
- `sudo nixos-rebuild build --flake .#<host>` evaluates and builds without switching (safe check).
- `nix flake update` refreshes `flake.lock` inputs.
- Shell helpers like `nr` and `nrb` are defined in `modules/home/users/gars.nix`.
- `fnix` and `fnixc` in `modules/home/users/gars.nix` format or check all Nix files except hardware configs.
- `swapstat` (defined in `modules/home/users/gars.nix`) shows swap usage plus zram status.

## Coding Style & Naming Conventions
- Use 2-space indentation and align braces with existing Nix style.
- Prefer lower-case, hyphenated filenames (for example `gui-base.nix`, `waybar-settings.nix`).
- Keep module names descriptive and scoped to their layer: `modules/system/<feature>.nix` vs `modules/home/<feature>.nix`.
- Keep host names stable; they are referenced directly in `flake.nix` output keys.
- Format Nix with `alejandra`.
- Format all Nix files except hardware configs:
- `rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra`

## System Services & Storage Notes
- `hosts/boreal/storage.nix` defines the ext4 mounts, swap, zram, and mountpoint tmpfiles rules. It now uses `my.primaryUser` for mount ownership instead of hardcoding `gars`.
- `hosts/boreal/networking.nix` turns on `networking.firewall` with `8096/tcp` and `2200/tcp` open; add other ports there before relying on them.
- `hosts/boreal/graphics.nix` enables `hardware.graphics.enable32Bit` and AMD graphics support, which the gaming profile relies on for Steam.
- `hosts/boreal/services.nix` supplies `my.jellyfin.*` values. `modules/system/jellyfin.nix` mounts a tmpfs transcode directory, creates `${config.my.jellyfin.dataDir}/{config,cache,data,log}` in `preStart`, and applies ACLs to every path listed in `my.jellyfin.mediaRoots`.

## Testing Guidelines
- There are no automated tests in this repository.
- Validate changes by building the target: `sudo nixos-rebuild build --flake .#boreal` or another affected output.
- For GUI changes (Waybar/Sway/Niri/Hyprland), do a local switch and visually confirm behavior.
- For gaming changes, validate `boreal-gaming` or `boreal-gamescope` specifically.

## Agent-Specific Instructions
- Agents must not run `nixos-rebuild` or perform switch/build actions.
- Agents must never edit `hosts/*/hardware-configuration.nix`.

## Commit Guidelines
- Commit history uses short, descriptive, lower-case sentences, sometimes with iteration notes (for example `moved sway config to modules/home/sway.nix - test 3`).
- Keep commit messages specific to the module or host being changed.
