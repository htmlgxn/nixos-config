# Reference

## Outputs

| Output | Host | System Profile | Home Profile |
| --- | --- | --- | --- |
| `boreal-tty` | `boreal` | `tty` | `cli` |
| `boreal-tty-cyberdeck` | `boreal` | `tty` | `cli-cyberdeck` |
| `boreal` | `boreal` | `sway` | `sway` |
| `boreal-gaming` | `boreal` | `sway-gaming` | `sway-gaming` |
| `boreal-gamescope` | `boreal` | `gamescope` | `gamescope` |
| `boreal-niri` | `boreal` | `niri` | `niri` |
| `boreal-hypr` | `boreal` | `hyprland` | `hyprland` |
| `nixos-vm` | `nixos-vm` | `tty` | `cli` |

## User Shell Helpers

Common aliases live in [`modules/home/users/gars.nix`](/home/gars/nixos-config/modules/home/users/gars.nix).

Rebuild helpers:

- `nr <output>` runs `sudo nixos-rebuild switch --flake ~/nixos-config/.#<output>`
- `nrb <output>` runs `sudo nixos-rebuild build --flake ~/nixos-config/.#<output>`
- `nrs` is a permanent shortcut for `nr boreal`
- `nrtty` is a permanent shortcut for `nr boreal-tty`

Supported outputs:

- `boreal`
- `boreal-gaming`
- `boreal-gamescope`
- `boreal-niri`
- `boreal-hypr`
- `boreal-tty`
- `boreal-tty-cyberdeck`
- `nixos-vm`

Important maintenance aliases:

- `fnix`
- `fnixc`
- `swapstat`

## Host Notes

### boreal

- `hosts/boreal/storage.nix` defines ext4 mounts, swap, zram, and mountpoint tmpfiles rules
- `hosts/boreal/graphics.nix` enables AMD graphics and 32-bit graphics support needed for Steam
- `hosts/boreal/networking.nix` opens `8096/tcp` and `2200/tcp`
- `hosts/boreal/services.nix` provides Jellyfin path values through `my.jellyfin.*`

### Jellyfin

`modules/system/jellyfin.nix` expects the host layer to supply:

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
- visually confirm GUI changes after a local switch
