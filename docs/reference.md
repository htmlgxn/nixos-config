# Reference

## Outputs

| Output       | Type         | Host/User           | System Profile | Home Profile | Home Overlays |
| ------------ | ------------ | ------------------- | -------------- | ------------ | ------------- |
| `boreal-tty` | NixOS        | `boreal` / `gars`   | `tty`          | `cli`        | `ai`          |
| `boreal`     | NixOS        | `boreal` / `gars`   | `sway-full`    | `sway-full`  | `ai`          |
| `nixos-vm`   | NixOS        | `nixos-vm` / `gars` | `tty`          | `cli`        | none          |
| `rpi4-tty`   | NixOS        | `rpi4` / `gars`     | `tty`          | `cli`        | none          |
| `rpi4-sway`  | NixOS        | `rpi4` / `gars`     | `sway`         | `sway`       | none          |
| `macbook`    | nix-darwin   | `htmlgxn`           | n/a            | `cli`        | `ai`          |
| `fedora-mac` | Home Manager | `htmlgxn`           | n/a            | `cli`        | none          |
| `jetson`     | Home Manager | `gars`              | n/a            | `cli`        | none          |

## Home Overlay Groups

Home Manager outputs may include explicit overlay groups for feature composition:

- `ai`: `modules/home/ai.nix` — installs claude-code, qwen-code, codex, opencode, ollama runtime and development tools. Sets `my.ollamaPackage` to `pkgs.ollama` (hosts can override to `pkgs.ollama-rocm` or another variant via mkDefault).

Host-level Home Manager modules are applied per-output through the host descriptor:

- `hosts/boreal/home.nix` adds Boreal-specific overrides (e.g., `my.ollamaPackage = pkgs.ollama-rocm`, `my.terminal = "kitty"`) for `boreal` and `boreal-tty` outputs
- `hosts/macbook/home.nix` adds macOS-specific configuration
- `hosts/jetson/home.nix` enables `targets.genericLinux.enable` and sets CUDA paths

## User Shell Helpers

Shared aliases and SSH baseline live in [`modules/home/users/common.nix`](../modules/home/users/common.nix). The dedicated Nix helper surface lives in [`modules/home/nix-workflows.nix`](../modules/home/nix-workflows.nix). The full command guide is in [`docs/nix-workflows.md`](nix-workflows.md).

Rebuild helpers:

- `nr <output>` runs `nh os switch . -H <output>` (applies and diffs NixOS configurations)
- `nrb <output>` runs `nh os build . -H <output>` (builds without applying)
- `nrt <output>` runs `nh os test . -H <output>` (test the new system without rebooting)
- `nrd <output>` runs `nh os build -d . -H <output>` (dry-run with diff)
- `nrs` overrides `nr` for `boreal`, using `nh os switch . -H boreal`
- `nrtty` overrides `nr` for `boreal-tty`, using `nh os switch . -H boreal-tty`

Darwin helpers:

- `ndrs [output]` runs `nh darwin switch . -H <output>` (default: `macbook`)
- `ndrb [output]` runs `nh darwin build . -H <output>`

Home Manager helpers:

- `nhms [output]` runs `nh home switch . -c <output>` (default: `fedora-mac`)
- `nhmb [output]` runs `nh home build . -c <output>`

Other helpers:

- `ns [query]` runs `nix-search-tv` through `fzf` with inline preview
- `nout`, `noutn`, `noutd`, and `nouth` list the current flake outputs
- `ncheck` and `ncheck-full` provide the default repo validation sequences
- `nboh`, `ncopy`, `ncopy-test`, `ncopy-switch`, `nremote-build`, `nremote-test`, and `nremote-switch` cover cross-host NixOS deployment flows

`nr` and `nrb` validate against the current `nixosConfigurations` in the flake instead of a hardcoded shell list.

Important maintenance aliases:

- `fnix`
- `fnixc`
- `nfu`
- `nfu-input`
- `nlock`
- `nspace`
- `nspace-why`
- `ntop-store`
- `ngen-system`
- `ngen-hm`
- `ngen-all`
- `ndiff-system`
- `nclean-system`
- `nclean-hm`
- `nclean-all`
- `swapstat`
- `cdcont`
- `cdquad`
- `cdcomp`
- `cdnpmapp`
- `pc`
- `soft`

Neovim helpers:

- `:NixSearch` opens the same `nix-search-tv` picker inside Neovim
- `<leader>fn` runs `:NixSearch`

## Shared `my.*` Options

`modules/shared/options.nix` defines:

- `my.isNixOS`
- `my.borealHost`
- `my.ollamaPackage`
- `my.terminal`
- `my.dualKeyboardLayout`
- `my.showRootDisk`
- `my.wallpaper`
- `my.primaryUser`
- `my.repoRoot`
- `my.containersRoot`
- `my.terminalTheme`
- `my.guiTheme`
- `my.nvimTheme`
- `my.jellyfin.vaDriver`
- `my.jellyfin.dataDir`
- `my.jellyfin.mediaRoots`
- `my.jellyfin.transcodeSize`

`my.ollamaPackage` defaults to `pkgs.ollama` (via `ai.nix` overlay). Individual hosts can override via mkDefault:

- Boreal sets `my.ollamaPackage = pkgs.ollama-rocm` in `hosts/boreal/home.nix`

`my.terminal` acts as the terminal selector for GUI outputs:

- `foot` is the shared default (set in `modules/shared/options.nix`)
- Boreal overrides to `kitty` in `hosts/boreal/home.nix`
- `alacritty` is available as an alternative selection

## Host Notes

### boreal

- `hosts/boreal/storage.nix` defines ext4 mounts, the mergerfs pool, swap, zram, and mountpoint tmpfiles rules
- `hosts/boreal/graphics.nix` enables AMD graphics and 32-bit graphics support needed for Steam
- `hosts/boreal/networking.nix` opens `8096/tcp` and `2200/tcp`
- `hosts/boreal/services.nix` provides Jellyfin values through `my.jellyfin.*` and configures Soft Serve
- `hosts/boreal/home.nix` keeps Boreal-local HM additions such as self-referential SSH targets and hostname overrides
- `modules/system/containers.nix` enables Podman, sets the OCI backend to Podman, and installs `podman-compose`, `buildah`, and `skopeo`
- `/mnt/ironwolf` is the physical disk that previously lived at `/mnt/archive`
- `/mnt/archive` is now the merged view over `/mnt/ironwolf` and `/mnt/seagate6`
- `/mnt/backup` remains outside the merged pool

### cyberdeck

- Jetson Orin Nano target configuration (currently disabled in `parts/lib.nix` and `parts/nixos.nix`)
- `hosts/cyberdeck/configuration.nix` targets the Jetson via `hardware.nvidia-jetpack`
- the JetPack module comes from `jetpack-nixos` input

### rpi4

- `hosts/rpi4/configuration.nix` is the Raspberry Pi 4 host target
- `nixos-hardware.nixosModules.raspberry-pi-4` is imported through the host descriptor
- `rpi4-tty` and `rpi4-sway` use the shared ARM profile set (`tty`/`cli` and `gui`/`gui`), which omit Flatpak and gaming
- port `2200/tcp` is explicitly opened in the firewall

### macbook

- `hosts/macbook/configuration.nix` is a nix-darwin host configuration
- `hosts/macbook/home.nix` adds nushell library path and GitHub SSH configuration for macOS
- apply with `ndrs` (shorthand) or `nh darwin switch . -H macbook`

### jetson

- Standalone Home Manager target for Jetson Orin Nano (no NixOS system configuration)
- `hosts/jetson/home.nix` enables `targets.genericLinux.enable` and sets CUDA environment variables and library paths
- apply with `nhms jetson` or `nh home switch .#jetson`

## Services

### Soft Serve

See [`docs/soft-serve.md`](soft-serve.md) for the full usage guide.

Soft Serve runs on Boreal, managed by `hosts/boreal/services.nix` and `modules/system/soft-serve.nix`:

- SSH on port `23231`
- HTTP on port `23232`
- a static `soft-serve` system user owns the data directory
- the service requires `mnt-archive.mount` before starting

Note: Boreal firewall openings for Soft Serve are currently declared by the reusable system module rather than by `hosts/boreal/networking.nix`.

### Jellyfin

`modules/system/jellyfin.nix` reads:

- `my.jellyfin.vaDriver`
- `my.jellyfin.dataDir`
- `my.jellyfin.mediaRoots`
- `my.jellyfin.transcodeSize`

It then:

- creates the data directories in `preStart`
- mounts the transcode tmpfs
- applies ACLs to every media root
- requires those mountpoints before starting Jellyfin

## Validation

There are no automated tests in the repo.

Typical checks:

- evaluate outputs with `nix eval`
- build an affected target with `nrb <output>`
- apply Darwin changes with `ndrs [output]`
- apply standalone Home Manager changes with `nhms [output]`
- use [`docs/nix-workflows.md`](nix-workflows.md) for the full repo helper reference and recommended command sequences
- visually confirm GUI changes after a local switch
