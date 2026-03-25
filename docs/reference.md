# Reference

## Outputs

| Output | Type | Host/User | System Profile | Home Profile |
| --- | --- | --- | --- | --- |
| `boreal-tty` | NixOS | `boreal` | `tty` | `cli` |
| `boreal-tty-cyberdeck` | NixOS | `boreal` | `tty` | `cli-cyberdeck` |
| `boreal` | NixOS | `boreal` | `sway` | `sway` |
| `boreal-gaming` | NixOS | `boreal` | `sway-gaming` | `sway-gaming` |
| `boreal-gamescope` | NixOS | `boreal` | `gamescope` | `gamescope` |
| `boreal-niri` | NixOS | `boreal` | `niri` | `niri` |
| `boreal-hypr` | NixOS | `boreal` | `hyprland` | `hyprland` |
| `nixos-vm` | NixOS | `nixos-vm` | `tty` | `cli` |
| `cyberdeck-tty` | NixOS | `cyberdeck` | `tty` | `cli` |
| `rpi4-tty` | NixOS | `rpi4` | `tty` | `cli` |
| `rpi4-sway` | NixOS | `rpi4` | `sway-arm` | `sway-arm` |
| `rpi4-tty-cyberdeck` | NixOS | `rpi4` | `tty` | `cli-cyberdeck` |
| `macbook` | nix-darwin | `htmlgxn` | n/a | `cli` |
| `fedora-arm` | Home Manager | `htmlgxn` | n/a | `cli` |

## User Shell Helpers

Shared aliases live in [`modules/home/users/gars-common.nix`](/home/gars/nixos-config/modules/home/users/gars-common.nix). NixOS-only rebuild helpers live in [`modules/home/users/gars.nix`](/home/gars/nixos-config/modules/home/users/gars.nix).

Rebuild helpers:

- `nr <output>` runs `sudo nixos-rebuild switch --flake ~/nixos-config/.#<output>`
- `nrb <output>` runs `sudo nixos-rebuild build --flake ~/nixos-config/.#<output>`
- `nrs` is a permanent shortcut for `nr boreal`
- `nrtty` is a permanent shortcut for `nr boreal-tty`
- `ns [query]` runs `nix-search-tv` through `fzf` with inline preview

Supported outputs:

- `boreal`
- `boreal-gaming`
- `boreal-gamescope`
- `boreal-niri`
- `boreal-hypr`
- `boreal-tty`
- `boreal-tty-cyberdeck`
- `nixos-vm`
- `cyberdeck-tty`
- `rpi4-tty`
- `rpi4-sway`
- `rpi4-tty-cyberdeck`

Important maintenance aliases:

- `fnix`
- `fnixc`
- `swapstat`
- `cdcont`
- `cdquad`
- `cdcomp`
- `cdnpmapp`
- `pc`

Neovim helpers:

- `:NixSearch` opens the same `nix-search-tv` picker inside Neovim
- `<leader>fn` runs `:NixSearch`

## Host Notes

### boreal

- `hosts/boreal/storage.nix` defines ext4 mounts, the mergerfs pool, swap, zram, and mountpoint tmpfiles rules
- `hosts/boreal/graphics.nix` enables AMD graphics and 32-bit graphics support needed for Steam
- `hosts/boreal/networking.nix` opens `8096/tcp` and `2200/tcp`
- `hosts/boreal/services.nix` provides Jellyfin path values through `my.jellyfin.*`
- `modules/system/containers.nix` enables Podman, sets the OCI backend to Podman, and installs `podman-compose`, `buildah`, and `skopeo`
- `/mnt/ironwolf` is the physical disk that previously lived at `/mnt/archive`
- `/mnt/archive` is now the merged view over `/mnt/ironwolf` and `/mnt/seagate6`
- `/mnt/backup` remains outside the merged pool

### cyberdeck

- `hosts/cyberdeck/configuration.nix` targets Jetson Orin Nano via `hardware.nvidia-jetpack`
- the JetPack module comes from `jetpack-nixos` through `extraSystemModules` in `flake.nix`

### rpi4

- `hosts/rpi4/configuration.nix` is the Raspberry Pi 4 host target
- `nixos-hardware.nixosModules.raspberry-pi-4` is imported through `extraSystemModules`
- `rpi4-sway` uses `sway-arm` profiles that intentionally omit Flatpak

### macbook

- `hosts/macbook/configuration.nix` is a nix-darwin host
- apply with `darwin-rebuild switch --flake .#macbook`

### Jellyfin

`modules/system/jellyfin.nix` reads:

- `my.jellyfin.dataDir` (default `""`)
- `my.jellyfin.mediaRoots` (default `[]`)
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
- visually confirm GUI changes after a local switch
