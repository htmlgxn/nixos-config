# Repository Guidelines

## Project Structure & Module Organization
- `flake.nix` defines all NixOS and Home Manager outputs. Current NixOS outputs are `boreal-tty`, `boreal-tty-cyberdeck`, `boreal`, `boreal-gaming`, `boreal-gamescope`, `boreal-niri`, `boreal-hypr`, and `nixos-vm`.
- `hosts/<name>/configuration.nix` contains per-host system settings.
- `hosts/<name>/hardware-configuration.nix` is generated; do not edit it manually or via automation.
- `hosts/boreal/configuration.nix` is the main x86_64 desktop host. `hosts/cyberdeck/configuration.nix` is the aarch64 Jetson target. `hosts/nixos-vm/configuration.nix` is the VM profile.
- `modules/system/cli.nix` provides the shared TTY/system baseline. `modules/system/gui-base.nix` is shared by the compositor modules.
- `modules/system/sway.nix`, `modules/system/niri.nix`, and `modules/system/hyprland.nix` extend the GUI base with compositor-specific system services and packages.
- `modules/system/gamescope.nix` defines the minimal Steam + gamescope session profile and intentionally skips the shared GUI base.
- `modules/system/gaming.nix` adds system-level gaming support such as Steam and Proton compatibility packages.
- `modules/system/jellyfin.nix` configures the Jellyfin service (tmpfs transcodes, `preStart` directory creation, ACLs, tmpfiles-only ACL rules, and helper systemd options).
- `modules/system/flatpak.nix` enables the system-level Flatpak stack; `modules/home/flatpak.nix` handles the user-level remote + installs.
- `modules/home/cli.nix`, `modules/home/gui-base.nix`, `modules/home/sway.nix`, `modules/home/niri.nix`, `modules/home/hyprland.nix`, and `modules/home/gaming.nix` define shared Home Manager layers.
- `modules/home/users/<name>.nix` is the per-user Home Manager entrypoint; `modules/home/users/gars.nix` is the current user module.
- `modules/home/flatpak/packages.nix` and `modules/home/packages/{go,python,rust}` maintain curated package sets imported by the shared Home Manager stack.
- `home/gars/dots/` and `home/gars/nvim/` contain dotfiles and editor configuration referenced by Home Manager modules.

## Build, Test, and Development Commands
- These commands are for the human operator only. Agents must not run rebuilds or switch operations.
- `sudo nixos-rebuild switch --flake .#boreal` applies the production Sway configuration.
- `sudo nixos-rebuild switch --flake .#boreal-gaming` applies the Sway + Steam configuration.
- `sudo nixos-rebuild switch --flake .#boreal-gamescope` applies the minimal Steam + gamescope configuration.
- `sudo nixos-rebuild switch --flake .#boreal-niri` applies the Niri variant.
- `sudo nixos-rebuild switch --flake .#boreal-hypr` applies the Hyprland variant.
- `sudo nixos-rebuild switch --flake .#boreal-tty` applies the TTY-only boreal profile.
- `sudo nixos-rebuild switch --flake .#boreal-tty-cyberdeck` applies the TTY boreal profile with cyberdeck CLI packages.
- `sudo nixos-rebuild switch --flake .#nixos-vm` applies the VM target.
- `sudo nixos-rebuild build --flake .#<host>` evaluates and builds without switching (safe check).
- `nix flake update` refreshes `flake.lock` inputs.
- Aliases like `nrs`, `nrsgaming`, `nrgs`, `nrn`, `nrh`, and `nrtty` are defined in `modules/home/users/gars.nix`.
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
- `hosts/boreal/configuration.nix` defines ext4 mounts via the `mkExt4Mount` helper, keeps `/mnt/archive`, `/mnt/seagate6`, and `/mnt/backup` owned by `gars`, and relies on `systemd.tmpfiles.rules` for the mountpoints themselves. Update `swapDevices`, `zramSwap`, and `boot.kernel.sysctl."vm.swappiness"` there if your workload or swap layout changes.
- The same file also turns on `networking.firewall` with `8096/tcp` and `2200/tcp` open; add other ports there before relying on them.
- `hosts/boreal/configuration.nix` enables `hardware.graphics.enable32Bit` and AMD graphics support, which the gaming profile relies on for Steam.
- `modules/system/jellyfin.nix` maps the Jellyfin service, mounts a tmpfs transcode directory, and uses `preStart` to create `/mnt/archive/jellyfin/{config,cache,data,log}` because tmpfiles refuse to touch a subtree owned by `gars`. Its tmpfiles rules now only establish ACLs on `/mnt/seagate6`, and the service mounts/ACLs expect `/mnt/seagate6` to keep ownership with `gars` while granting Jellyfin `u:jellyfin:rx` access.

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
