# Reference

## Outputs

| Output | Type | Host/User | System Profile | Home Profile | Home Overlays |
| --- | --- | --- | --- | --- | --- |
| `boreal-tty` | NixOS | `boreal` / `gars` | `tty` | `cli` | `cli-extras`, `ai-cli-all`, `ai-ollama-rocm` |
| `boreal-tty-cyberdeck` | NixOS | `boreal` / `gars` | `tty` | `cli-cyberdeck` | `cli-extras`, `ai-cli-all`, `ai-ollama-rocm` |
| `boreal` | NixOS | `boreal` / `gars` | `sway` | `sway` | `cli-extras`, `boreal-gui`, `boreal-desktop` |
| `boreal-gaming` | NixOS | `boreal` / `gars` | `sway-gaming` | `sway-gaming` | `cli-extras`, `boreal-gui`, `boreal-desktop` |
| `boreal-gamescope` | NixOS | `boreal` / `gars` | `gamescope` | `gamescope` | none |
| `boreal-niri` | NixOS | `boreal` / `gars` | `niri` | `niri` | `cli-extras`, `boreal-gui` |
| `boreal-hypr` | NixOS | `boreal` / `gars` | `hyprland` | `hyprland` | `cli-extras`, `boreal-gui` |
| `nixos-vm` | NixOS | `nixos-vm` / `gars` | `tty` | `cli` | none |
| `cyberdeck-tty` | NixOS | `cyberdeck` / `gars` | `tty` | `cli` | none |
| `rpi4-tty` | NixOS | `rpi4` / `gars` | `tty` | `cli` | none |
| `rpi4-sway` | NixOS | `rpi4` / `gars` | `sway-arm` | `sway-arm` | none |
| `rpi4-sway-full` | NixOS | `rpi4` / `gars` | `sway-arm` | `sway-arm-full` | none |
| `rpi4-tty-cyberdeck` | NixOS | `rpi4` / `gars` | `tty` | `cli-cyberdeck` | none |
| `macbook` | nix-darwin | `htmlgxn` | n/a | `cli` | `ai-cli-all` |
| `fedora-arm` | Home Manager | `htmlgxn` | n/a | `cli` | none |

## Home Overlay Groups

These are the explicit home-level add-on groups selected by outputs:

- `ai-cli-orchestrators`: `modules/home/ai-cli-orchestrators.nix` (empty placeholder for future CLI orchestration tooling)
- `ai-cli-agents`: `modules/home/ai-cli-agents.nix`
- `ai-cli-opencode`: `modules/home/ai-cli-opencode.nix`
- `ai-cli-extras`: `modules/home/ai-cli-extras.nix`
- `ai-cli-all`: `ai-cli-orchestrators`, `ai-cli-agents`, `ai-cli-opencode`, and `ai-cli-extras`
- `ai-ollama`: `modules/home/ai-ollama.nix` for generic Ollama enablement
- `ai-ollama-rocm`: `ai-ollama` plus `modules/home/ai-ollama-rocm.nix`
- `cli-extras`: `modules/home/cli-extras.nix`
- `boreal-gui`: `ai-cli-all`, `ai-ollama-rocm`, plus `modules/home/brave-bookmarks-sync.nix`
- `boreal-desktop`: inline Boreal desktop defaults for keyboard layout, root-disk waybar module, terminal preference, and `kitty`

Host-level Home Manager modules are separate from overlay groups:

- `hosts/boreal/home.nix` is included for every Boreal output through the host descriptor

## User Shell Helpers

Shared aliases and SSH baseline live in [`modules/home/users/common.nix`](../modules/home/users/common.nix). The dedicated Nix helper surface lives in [`modules/home/nix-workflows.nix`](../modules/home/nix-workflows.nix). The full command guide is in [`docs/nix-workflows.md`](nix-workflows.md).

Rebuild helpers:

- `nr <output>` runs `sudo nixos-rebuild switch --flake ~/nixos-config/.#<output>`
- `nrb <output>` runs `sudo nixos-rebuild build --flake ~/nixos-config/.#<output>`
- `nrt <output>` runs `sudo nixos-rebuild test --flake ~/nixos-config/.#<output>`
- `nrd <output>` runs `sudo nixos-rebuild dry-build --flake ~/nixos-config/.#<output>`
- `nrs` is a permanent shortcut for `nr boreal`
- `nrtty` is a permanent shortcut for `nr boreal-tty`
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
- `my.dotfilesRoot`
- `my.dotfilesNixPath`
- `my.containersRoot`
- `my.terminalTheme`
- `my.guiTheme`
- `my.nvimTheme`
- `my.jellyfin.vaDriver`
- `my.jellyfin.dataDir`
- `my.jellyfin.mediaRoots`
- `my.jellyfin.transcodeSize`

`my.ollamaPackage` is now intended to be set explicitly by `ai-ollama` overlays rather than implicitly by user modules.

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

- `hosts/cyberdeck/configuration.nix` targets Jetson Orin Nano via `hardware.nvidia-jetpack`
- the JetPack module comes from `jetpack-nixos` through the host descriptor

### rpi4

- `hosts/rpi4/configuration.nix` is the Raspberry Pi 4 host target
- `nixos-hardware.nixosModules.raspberry-pi-4` is imported through the host descriptor
- `rpi4-sway` uses lean ARM Sway profiles that intentionally omit Flatpak and heavier desktop extras
- port `2200/tcp` is explicitly opened in the firewall

### macbook

- `hosts/macbook/configuration.nix` is a nix-darwin host
- apply with `darwin-rebuild switch --flake .#macbook`

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
- build an affected target with `sudo nixos-rebuild build --flake .#<output>`
- apply Darwin changes with `darwin-rebuild switch --flake .#macbook`
- apply standalone Home Manager changes with `home-manager switch --flake .#fedora-arm`
- use [`docs/nix-workflows.md`](nix-workflows.md) for the repo helper equivalents and the recommended command combos
- visually confirm GUI changes after a local switch
