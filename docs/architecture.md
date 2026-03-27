# Architecture

## Layering Model

The repo is intentionally split into four layers:

- Hosts: machine-specific hardware, storage, networking, users, and service-local values
- System profiles: NixOS module sets that define TTY, desktop, gaming, and service behavior
- Home profiles: Home Manager module sets that define CLI tools, desktop packages, dotfiles, and user-facing defaults
- Shared local options: repo-specific values exposed through `my.*`

`flake.nix` composes those layers rather than hardcoding each final output by hand.

## Flake Composition

The flake uses four descriptor attrsets plus three output maps:

- `users`: per-user Home Manager entrypoints and optional extra home modules
- `hosts`: per-host system, entry module, host-local extra system modules, and whether CLI extras are included
- `homeProfiles`: reusable Home Manager module lists
- `systemProfiles`: reusable NixOS module lists
- `nixosOutputDefs`: final NixOS outputs that select a host, user, system profile, and home profile
- `darwinOutputDefs`: final nix-darwin outputs that select a user, home profile, and Darwin system
- `homeOutputDefs`: final standalone Home Manager outputs that select a user, home profile, and system

Three builders turn these maps into flake outputs: `mkOutput` (NixOS), `mkDarwinOutput` (nix-darwin), and `mkHomeOutput` (standalone Home Manager).

## Host Structure

Each host should keep `configuration.nix` thin and use imports for non-trivial concerns.

For `boreal`, those concerns are split into:

- `base.nix`
- `graphics.nix`
- `storage.nix`
- `networking.nix`
- `users.nix`
- `services.nix`

Use the same approach for other hosts once they become complex enough to justify it.

## Shared Local Options

`modules/shared/my-options.nix` defines repo-local values used across NixOS and Home Manager:

- `my.primaryUser`
- `my.repoRoot`
- `my.dotfilesRoot`
- `my.containersRoot`
- `my.wallpaper`
- `my.isNixOS`
- `my.ollamaPackage`
- `my.dualKeyboardLayout`
- `my.showRootDisk`
- `my.terminalTheme`
- `my.guiTheme`
- `my.nvimTheme`
- `my.jellyfin.dataDir`
- `my.jellyfin.mediaRoots`
- `my.jellyfin.transcodeSize`

`my.jellyfin.dataDir` and `my.jellyfin.mediaRoots` have safe defaults (`""` and `[]`) so shared HM-only targets can evaluate without host-level Jellyfin values.

Use `my.*` when a value is local to this repo and reused across modules, but not general enough to justify a public NixOS/Home Manager option schema of its own.

## Host-Specific Services

Host-specific services belong in the host's own `services.nix` rather than a reusable system profile. For example, Soft Serve runs on boreal and is configured in `hosts/boreal/services.nix`.

## Desktop and Gaming Profiles

Desktop-style outputs are assembled from:

- `modules/system/cli.nix`
- `modules/system/gui-base.nix`
- a compositor-specific system module
- optional system additions like gaming or Flatpak
- matching Home Manager profile modules

`gamescope` is intentionally separate from the full GUI path. It uses Steam and gamescope without `gui-base.nix` or the larger desktop package set.

## Documentation Policy

Markdown docs are the canonical place for:

- architecture explanations
- repo workflows
- output and service reference
- “how to add/change” guidance

Nix file headers should stay short. Keep comments only when they explain:

- non-obvious intent
- unusual constraints
- behavior that would be hard to infer from the code alone
