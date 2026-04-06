# Repository Guidelines

## Project Structure & Module Organization

- Canonical operator docs now live in `README.md`, `docs/architecture.md`, `docs/workflows.md`, `docs/reference.md`, `hosts/README.md`, and `modules/README.md`.
- `flake.nix` defines outputs through descriptor attrsets for `users`, `hosts`, `homeProfiles`, `systemProfiles`, and three output maps: `nixosOutputDefs`, `darwinOutputDefs`, and `homeOutputDefs`. Three builder functions produce outputs: `mkOutput` (NixOS), `mkDarwinOutput` (nix-darwin), and `mkHomeOutput` (standalone Home Manager).
- Current NixOS outputs are `boreal-tty`, `boreal`, `nixos-vm`, `rpi4-tty`, and `rpi4-sway`. Darwin output: `macbook`. Standalone HM outputs: `fedora-arm`.
- Flake inputs include `nixpkgs`, `home-manager`, `nix-darwin`, `nixos-hardware`, `jetpack-nixos`, and `bookokrat`.
- `hosts/<name>/configuration.nix` contains per-host system settings.
- `hosts/<name>/hardware-configuration.nix` is generated; do not edit it manually or via automation.
- `hosts/boreal/configuration.nix` is now a thin import list; the boreal host is split into `base.nix`, `graphics.nix`, `storage.nix`, `networking.nix`, `users.nix`, and `services.nix`. `hosts/cyberdeck/configuration.nix` is the aarch64 Jetson target. `hosts/nixos-vm/configuration.nix` is the VM profile. `hosts/rpi4/configuration.nix` is the Raspberry Pi 4 target. `hosts/macbook/configuration.nix` is the nix-darwin target.
- `modules/shared/options.nix` defines the repo-local `my.*` namespace used for values like `my.repoRoot`, `my.dotfilesRoot`, `my.dotfilesNixPath`, `my.primaryUser`, `my.isNixOS`, `my.borealHost`, `my.ollamaPackage`, `my.wallpaper`, `my.terminal`, `my.dualKeyboardLayout`, `my.showRootDisk`, `my.containersRoot`, `my.terminalTheme`, `my.guiTheme`, `my.nvimTheme`, and `my.jellyfin.*`.
- `containers/` is the repo-managed workspace for Podman/Quadlet, compose-style apps, and direct npm app experiments.
- `modules/system/cli.nix` provides the shared TTY/system baseline (SSH on port 2200, Avahi mDNS for `.local` resolution, PipeWire audio). `modules/system/gui-base.nix` is shared by the compositor modules.
- `modules/system/containers.nix` is the shared Podman-first container runtime module.
- `modules/system/sway.nix` extends the GUI base with Sway-specific system services and packages.
- `modules/system/gaming.nix` adds system-level gaming support such as Steam and Proton compatibility packages (included in the `sway` system profile).
- `modules/system/jellyfin.nix` is now driven by `my.jellyfin.*` values supplied by the host layer instead of hardcoding boreal paths.
- `modules/system/soft-serve.nix` enables the Soft Serve git server (`services.soft-serve`) and opens ports 23231 (SSH) and 23232 (HTTP). Imported by `hosts/boreal/services.nix`.
- `modules/system/flatpak.nix` enables the system-level Flatpak stack; `modules/home/flatpak.nix` handles the user-level remote + installs.
- `modules/home/cli.nix`, `modules/home/gui-base.nix`, `modules/home/sway.nix`, and `modules/home/gaming.nix` define shared Home Manager layers.
- AI tooling is split into modular home modules: `modules/home/ai-cli-agents.nix`, `modules/home/ai-cli-extras.nix`, `modules/home/ai-cli-orchestrators.nix` (empty placeholder), `modules/home/ai-ollama.nix`, and `modules/home/ai-ollama-rocm.nix`. These are included through explicit home overlay groups such as `ai-cli-all`, `ai-ollama`, and `ai-ollama-rocm`.
- `modules/home/containers.nix` adds shared container/npm user tooling and shell helpers.
- `modules/home/users/common.nix` holds the shared shell, editor, SSH, and theme baseline. `modules/home/users/gars.nix` (NixOS/Linux user) and `modules/home/users/htmlgxn.nix` (macOS/Fedora user) both import it and set platform-specific paths.
- `modules/home/flatpak/packages.nix` and `modules/home/packages/{go,python,rust}` maintain curated package sets imported by the shared Home Manager stack.
- `home/gars/dots/` and `home/gars/nvim/` contain dotfiles and editor configuration referenced by Home Manager modules.

## Platform Abstraction

- `my.isNixOS` (bool, default `true`) signals whether the host is NixOS. Set to `false` in nix-darwin and standalone HM user modules.
- `my.ollamaPackage` (nullOr package, default `null`) selects the local AI runtime package per-output (e.g., `pkgs.ollama-rocm` through Boreal's `ai-ollama-rocm` overlay, `pkgs.ollama` through `ai-ollama`, `null` to skip).
- `my.dualKeyboardLayout` (bool, default `false`) enables the dual us/graphite keyboard layout and waybar keyboard switcher. Set to `true` for boreal outputs.
- `my.showRootDisk` (bool, default `false`) shows the root disk usage % module in waybar. Set to `true` for boreal outputs.
- `my.wallpaper` (path) is the wallpaper image used by swaybg in sway and niri. Set in `gars.nix` to `home/gars/wallpapers/default.jpg` inside the repo.
- `modules/home/cli.nix` uses `lib.optionals pkgs.stdenv.isLinux` for Linux-only packages (`powertop`) and `lib.optionals (config.my.ollamaPackage != null)` for the ollama conditional.
- `modules/home/gui-base.nix` uses `lib.optionals pkgs.stdenv.isLinux` for Linux-only GUI packages (`freecad`, `libreoffice-fresh`).
- `modules/home/packages/python/default.nix` uses `lib.optionals pkgs.stdenv.isLinux` for `stdenv.cc.cc.lib`.
- `modules/home/cli-extras.nix` uses `lib.optionals pkgs.stdenv.isx86_64` for x86_64-only packages.
- ARM profiles (`sway-arm`) omit Flatpak, gaming, and heavier desktop extras.

## Build, Test, and Development Commands

- These commands are for the human operator only. Agents must not run rebuilds or switch operations.
- `nr <output>` switches to a named output; supported NixOS values are `boreal`, `boreal-tty`, `nixos-vm`, `rpi4-tty`, and `rpi4-sway`.
- `nrb <output>` builds a named output without switching.
- `nrs` and `nrtty` remain as permanent shortcuts for `boreal` and `boreal-tty`.
- `ns [query]` runs `nix-search-tv` through `fzf` with preview.
- `sudo nixos-rebuild build --flake .#<host>` evaluates and builds without switching (safe check).
- For nix-darwin: `darwin-rebuild switch --flake .#macbook`.
- For standalone HM: `home-manager switch --flake .#fedora-arm`.
- `nix flake update` refreshes `flake.lock` inputs.
- Shared navigation and SSH aliases live in `modules/home/users/common.nix`. The main Nix helper surface (`nr`, `nrb`, `ns`, `ncheck`, `nboh`, `nclean-all`, etc.) lives in `modules/home/nix-workflows.nix`.
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
- `hosts/boreal/networking.nix` turns on `networking.firewall` with `8096/tcp` and `2200/tcp` open. Soft Serve ports are opened by `modules/system/soft-serve.nix`; add other host-only ports in `hosts/boreal/networking.nix` before relying on them.
- `hosts/boreal/graphics.nix` enables `hardware.graphics.enable32Bit` and AMD graphics support, which the gaming profile relies on for Steam.
- `hosts/boreal/services.nix` supplies `my.jellyfin.*` values. `modules/system/jellyfin.nix` mounts a tmpfs transcode directory, creates `${config.my.jellyfin.dataDir}/{config,cache,data,log}` in `preStart`, and applies ACLs to every path listed in `my.jellyfin.mediaRoots`.

## Testing Guidelines

- There are no automated tests in this repository.
- Validate changes by building the target: `sudo nixos-rebuild build --flake .#boreal` or another affected output.
- For GUI changes (Waybar/Sway), do a local switch and visually confirm behavior.

## Agent-Specific Instructions

- Agents must not run `nixos-rebuild`, `darwin-rebuild`, or `home-manager switch` operations.
- Agents must never edit `hosts/*/hardware-configuration.nix`.
- Primary compositor is Sway. Do not add support for other compositors unless explicitly requested.

## Commit Guidelines

- Commit history uses short, descriptive, lower-case sentences, sometimes with iteration notes (for example `moved sway config to modules/home/sway.nix - test 3`).
- Keep commit messages specific to the module or host being changed.
