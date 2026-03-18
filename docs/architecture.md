# Architecture

## Layering Model

The repo is intentionally split into four layers:

- Hosts: machine-specific hardware, storage, networking, users, and service-local values
- System profiles: NixOS module sets that define TTY, desktop, gaming, and service behavior
- Home profiles: Home Manager module sets that define CLI tools, desktop packages, dotfiles, and user-facing defaults
- Shared local options: repo-specific values exposed through `my.*`

`flake.nix` composes those layers rather than hardcoding each final output by hand.

## Flake Composition

The flake uses five descriptor attrsets:

- `users`: per-user Home Manager entrypoints and optional extra home modules
- `hosts`: per-host system, entry module, host-local extra system modules, and whether CLI extras are included
- `homeProfiles`: reusable Home Manager module lists
- `systemProfiles`: reusable NixOS module lists
- `outputDefs`: final named outputs that select a host, user, system profile, and home profile

This means most structural changes happen by editing descriptors rather than writing new helper functions.

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
- `my.jellyfin.dataDir`
- `my.jellyfin.mediaRoots`
- `my.jellyfin.transcodeSize`

Use `my.*` when a value is local to this repo and reused across modules, but not general enough to justify a public NixOS/Home Manager option schema of its own.

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
