# Repository Guidelines

## Project Structure & Module Organization
- Canonical operator docs now live in `README.md`, `docs/architecture.md`, `docs/workflows.md`, `docs/reference.md`, `hosts/README.md`, and `modules/README.md`.
- `flake.nix` defines outputs through descriptor attrsets for `users`, `hosts`, `homeProfiles`, `systemProfiles`, and three output maps: `nixosOutputDefs`, `darwinOutputDefs`, and `homeOutputDefs`. Three builder functions produce outputs: `mkOutput` (NixOS), `mkDarwinOutput` (nix-darwin), and `mkHomeOutput` (standalone Home Manager).
- Current NixOS outputs are `boreal-tty`, `boreal-tty-cyberdeck`, `boreal`, `boreal-gaming`, `boreal-gamescope`, `boreal-niri`, `boreal-hypr`, `nixos-vm`, `cyberdeck-tty`, `rpi4-tty`, `rpi4-sway`, `rpi4-sway-full`, and `rpi4-tty-cyberdeck`. Darwin output: `macbook`. Standalone HM output: `fedora-arm`.
- Flake inputs include `nixpkgs`, `home-manager`, `nix-darwin`, `nixos-hardware`, `jetpack-nixos`, and `bookokrat`.
- `hosts/<name>/configuration.nix` contains per-host system settings.
- `hosts/<name>/hardware-configuration.nix` is generated; do not edit it manually or via automation.
- `hosts/boreal/configuration.nix` is now a thin import list; the boreal host is split into `base.nix`, `graphics.nix`, `storage.nix`, `networking.nix`, `users.nix`, and `services.nix`. `hosts/cyberdeck/configuration.nix` is the aarch64 Jetson target. `hosts/nixos-vm/configuration.nix` is the VM profile. `hosts/rpi4/configuration.nix` is the Raspberry Pi 4 target. `hosts/macbook/configuration.nix` is the nix-darwin target.
- `modules/shared/my-options.nix` defines the repo-local `my.*` namespace used for values like `my.repoRoot`, `my.dotfilesRoot`, `my.primaryUser`, `my.isNixOS`, `my.ollamaPackage`, `my.wallpaper`, `my.dualKeyboardLayout`, `my.showRootDisk`, `my.containersRoot`, `my.terminalTheme`, `my.guiTheme`, `my.nvimTheme`, and `my.jellyfin.*`.
- `containers/` is the repo-managed workspace for Podman/Quadlet, compose-style apps, and direct npm app experiments.
- `modules/system/cli.nix` provides the shared TTY/system baseline (SSH on port 2200, Avahi mDNS for `.local` resolution, PipeWire audio). `modules/system/gui-base.nix` is shared by the compositor modules.
- `modules/system/containers.nix` is the shared Podman-first container runtime module.
- `modules/system/sway.nix`, `modules/system/niri.nix`, and `modules/system/hyprland.nix` extend the GUI base with compositor-specific system services and packages.
- `modules/system/gamescope.nix` defines the minimal Steam + gamescope session profile and intentionally skips the shared GUI base.
- `modules/system/gaming.nix` adds system-level gaming support such as Steam and Proton compatibility packages.
- `modules/system/jellyfin.nix` is now driven by `my.jellyfin.*` values supplied by the host layer instead of hardcoding boreal paths.
- `modules/system/soft-serve.nix` enables the Soft Serve git server (`services.soft-serve`) and opens ports 23231 (SSH) and 23232 (HTTP). Imported by `hosts/boreal/services.nix`.
- `modules/system/flatpak.nix` enables the system-level Flatpak stack; `modules/home/flatpak.nix` handles the user-level remote + installs.
- `modules/home/cli.nix`, `modules/home/gui-base.nix`, `modules/home/sway.nix`, `modules/home/niri.nix`, `modules/home/hyprland.nix`, and `modules/home/gaming.nix` define shared Home Manager layers.
- `modules/home/ai-agents.nix` is an optional module containing AI agent CLI tools. It is included via `extraHomeModules` in output definitions that want the full AI toolkit and is omitted from lightweight targets.
- `modules/home/containers.nix` adds shared container/npm user tooling and shell helpers.
- `modules/home/users/gars-common.nix` holds shared shell, editor, and theme configuration. `modules/home/users/gars.nix` (NixOS/Linux user) and `modules/home/users/htmlgxn.nix` (macOS/Fedora user) both import it and set platform-specific paths.
- `modules/home/flatpak/packages.nix` and `modules/home/packages/{go,python,rust}` maintain curated package sets imported by the shared Home Manager stack.
- `home/gars/dots/` and `home/gars/nvim/` contain dotfiles and editor configuration referenced by Home Manager modules.

## Platform Abstraction
- `my.isNixOS` (bool, default `true`) signals whether the host is NixOS. Set to `false` in nix-darwin and standalone HM user modules.
- `my.ollamaPackage` (nullOr package, default `null`) selects the Ollama variant per-host (e.g., `pkgs.ollama-rocm` on boreal, `pkgs.ollama` on macOS, `null` to skip).
- `my.dualKeyboardLayout` (bool, default `false`) enables the dual us/graphite keyboard layout and waybar keyboard switcher. Set to `true` for boreal outputs.
- `my.showRootDisk` (bool, default `false`) shows the root disk usage % module in waybar. Set to `true` for boreal outputs.
- `my.wallpaper` (path) is the wallpaper image used by swaybg in sway and niri. Set in `gars.nix` to `home/gars/wallpapers/default.jpg` inside the repo.
- `modules/home/cli.nix` uses `lib.optionals pkgs.stdenv.isLinux` for Linux-only packages (`powertop`) and `lib.optionals (config.my.ollamaPackage != null)` for the ollama conditional.
- `modules/home/gui-base.nix` uses `lib.optionals pkgs.stdenv.isLinux` for Linux-only GUI packages (`freecad`, `libreoffice-fresh`).
- `modules/home/packages/python/default.nix` uses `lib.optionals pkgs.stdenv.isLinux` for `stdenv.cc.cc.lib`.
- `modules/home/cli-extras.nix` uses `lib.optionals pkgs.stdenv.isx86_64` for x86_64-only packages.
- ARM homeProfiles (`sway-arm`) and systemProfiles (`sway-arm`) omit Flatpak modules.

## Build, Test, and Development Commands
- These commands are for the human operator only. Agents must not run rebuilds or switch operations.
- `nr <output>` switches to a named output; supported NixOS values are `boreal`, `boreal-gaming`, `boreal-gamescope`, `boreal-niri`, `boreal-hypr`, `boreal-tty`, `boreal-tty-cyberdeck`, `nixos-vm`, `cyberdeck-tty`, `rpi4-tty`, `rpi4-sway`, `rpi4-sway-full`, and `rpi4-tty-cyberdeck`.
- `nrb <output>` builds a named output without switching.
- `nrs` and `nrtty` remain as permanent shortcuts for `boreal` and `boreal-tty`.
- `ns [query]` runs `nix-search-tv` through `fzf` with preview.
- `sudo nixos-rebuild build --flake .#<host>` evaluates and builds without switching (safe check).
- For nix-darwin: `darwin-rebuild switch --flake .#macbook`.
- For standalone HM: `home-manager switch --flake .#fedora-arm`.
- `nix flake update` refreshes `flake.lock` inputs.
- Shell helpers like `nr`, `nrb`, and `ns` are defined in `modules/home/users/gars.nix`. Shared aliases (`fnix`, `fnixc`, etc.) are in `modules/home/users/gars-common.nix`.
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
- Agents must not run `nixos-rebuild`, `darwin-rebuild`, or `home-manager switch` operations.
- Agents must never edit `hosts/*/hardware-configuration.nix`.
- Primary compositor is Sway. Do not spend time adding theming/config for other compositors (Hyprland, Niri) unless explicitly requested. Existing support for them is fine to leave in place.

## Commit Guidelines
- Commit history uses short, descriptive, lower-case sentences, sometimes with iteration notes (for example `moved sway config to modules/home/sway.nix - test 3`).
- Keep commit messages specific to the module or host being changed.
