# Repository Guidelines

## Project Structure & Module Organization
- `flake.nix` defines all NixOS and Home Manager outputs. Host targets include `boreal`, `boreal-niri`, and `nixos-vm`.
- `hosts/<name>/configuration.nix` contains per-host system settings.
- `hosts/<name>/hardware-configuration.nix` is generated; do not edit it manually or via automation.
- `modules/system/cli.nix` enables `openssh`, installs the base CLI tooling, and is imported by every host profile.
- `modules/system/gui-base.nix` is shared between Sway and Niri; it wires polkit, pipewire, waybar, greetd, portals, fonts, and additional GTK/QT theming before the compositor-specific modules. 
- `modules/system/sway.nix` / `modules/system/niri.nix` build on that shared base while providing compositor-specific services, fonts, and environment packages.
- `modules/system/jellyfin.nix` configures the Jellyfin service (tmpfs transcodes, `preStart` directory creation, ACLs, tmpfiles-only ACL rules, and helper systemd options).
- `modules/system/flatpak.nix` enables the system-level Flatpak stack; `modules/home/flatpak.nix` handles the user-level remote + installs.
- `modules/home/cli.nix` brings the CLI package list; `modules/home/cli-extras.nix` is for extra or machine-specific binaries and is enabled via `hmExtras` (see `hmExtras` in `flake.nix`).
- `modules/home/gui-base.nix` / `modules/home/sway.nix` / `modules/home/niri.nix` manage desktop packages, dotfiles, and extra keybindings/Waybar settings.
- `modules/home/flatpak/packages.nix` and `modules/home/packages/{go,python,rust}` maintain curated language toolsets that `home/gars/home.nix` imports.
- `home/gars/home.nix` is the primary Home Manager entrypoint for user `gars`.
- `home/gars/dots/` and `home/gars/nvim/` contain dotfiles and editor configuration referenced by Home Manager.

## Build, Test, and Development Commands
- These commands are for the human operator only. Agents must not run rebuilds or switch operations.
- `sudo nixos-rebuild switch --flake .#boreal` applies the production Sway configuration.
- `sudo nixos-rebuild switch --flake .#boreal-niri` applies the Niri variant.
- `sudo nixos-rebuild switch --flake .#nixos-vm` applies the VM target.
- `sudo nixos-rebuild build --flake .#<host>` evaluates and builds without switching (safe check).
- `nix flake update` refreshes `flake.lock` inputs.
- Aliases like `nrs`, `nrn`, `nrsg` are defined in `home/gars/home.nix` for convenience.
- `swapstat` (defined in `home/gars/home.nix`) shows swap usage plus zram status.

## Coding Style & Naming Conventions
- Use 2-space indentation and align braces with existing Nix style.
- Prefer lower-case, hyphenated filenames (for example `gui-base.nix`, `waybar-settings.nix`).
- Keep module names descriptive and scoped to their layer: `modules/system/<feature>.nix` vs `modules/home/<feature>.nix`.
- Keep host names stable; they are referenced directly in `flake.nix` output keys.
- Format Nix with `alejandra`.
- Format all Nix files except hardware configs:
- `rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra`

## System Services & Storage Notes
- `hosts/boreal/configuration.nix` defines ext4 mounts via the `mkExt4Mount` helper, keeps `/mnt/archive`, `/mnt/seagate6`, and `/mnt/backup` owned by `gars`, and relies on `systemd.tmpfiles.rules` for the mountpoints themselves. Update `swapDevices`, `zramSwap`, and `boot.kernel.sysctl."vm.swappiness"` there if your workload or swap layout changes.
- The same file also turns on `networking.firewall` with only `8096/tcp` open for Jellyfin; add other ports before enabling the firewall globally.
- `modules/system/jellyfin.nix` maps the Jellyfin service, mounts a tmpfs transcode directory, and uses `preStart` to create `/mnt/archive/jellyfin/{config,cache,data,log}` because tmpfiles refuse to touch a subtree owned by `gars`. Its tmpfiles rules now only establish ACLs on `/mnt/seagate6`, and the service mounts/ACLs expect `/mnt/seagate6` to keep ownership with `gars` while granting Jellyfin `u:jellyfin:rx` access.

## Testing Guidelines
- There are no automated tests in this repository.
- Validate changes by building the target: `sudo nixos-rebuild build --flake .#boreal`.
- For GUI changes (Waybar/Sway/Niri), do a local switch and visually confirm behavior.

## Agent-Specific Instructions
- Agents must not run `nixos-rebuild` or perform switch/build actions.
- Agents must never edit `hosts/*/hardware-configuration.nix`.

## Commit Guidelines
- Commit history uses short, descriptive, lower-case sentences, sometimes with iteration notes (for example `moved sway config to modules/home/sway.nix - test 3`).
- Keep commit messages specific to the module or host being changed.
