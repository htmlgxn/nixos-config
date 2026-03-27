# Architecture

## Design Goal

This repo is optimized for modular assembly:

- each output should be created by selecting reusable pieces
- host-specific values should stay in `hosts/`
- shared behavior should live in `modules/`
- repo-local cross-layer values should flow through `my.*`
- heavyweight features should be opt-in and visible at the output definition

The target state is that adding a new output definition is mostly a selection task, not a refactor.

## Layering Model

The repo is intentionally split into four layers:

- hosts: machine-specific hardware, storage, networking, users, service-local values, and narrowly host-local Home Manager additions
- system profiles: NixOS module sets that define TTY, desktop, gaming, and service behavior
- home profiles: Home Manager module sets that define CLI tools, desktop packages, dotfiles, and user-facing defaults
- shared local options: repo-specific values exposed through `my.*`

`flake.nix` composes those layers instead of hardcoding each final output by hand.

## Flake Composition

The flake uses four descriptor attrsets plus three output maps:

- `users`: per-user Home Manager entrypoints and user-local values
- `hosts`: per-host system, entry module, host-local extra system modules, optional host-level Home Manager modules, and the target platform
- `homeProfiles`: reusable Home Manager module lists
- `systemProfiles`: reusable NixOS module lists
- `nixosOutputDefs`: final NixOS outputs that select a host, user, system profile, home profile, and optional home overlay groups
- `darwinOutputDefs`: final nix-darwin outputs that select a user, home profile, Darwin system, and optional home overlay groups
- `homeOutputDefs`: final standalone Home Manager outputs that select a user, home profile, target system, and optional home overlay groups

Three builders turn these maps into flake outputs: `mkOutput` (NixOS), `mkDarwinOutput` (nix-darwin), and `mkHomeOutput` (standalone Home Manager).

## Output Assembly Rules

Every output should be understandable as:

1. shared defaults
2. one host
3. one system profile
4. one user
5. one home profile
6. zero or more explicit overlays

Keep selection visible at the output definition. If an output needs AI tooling, heavy desktop packages, or host-specific HM tweaks, that should be obvious from the output descriptor or a clearly named overlay group, not hidden behind an unrelated toggle.

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

Host-local Home Manager modules are allowed when a host needs values or narrow behavior that do not belong in shared profiles. Keep them value-oriented where possible.

## Shared Local Options

`modules/shared/options.nix` defines repo-local values used across NixOS and Home Manager:

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

`my.jellyfin.dataDir` and `my.jellyfin.mediaRoots` have safe defaults so shared HM-only targets can evaluate without host-level Jellyfin values.

Use `my.*` when a value is local to this repo and reused across modules, but not general enough to justify a public NixOS or Home Manager option schema of its own.

## Ownership Rules

Good fits for `hosts/`:

- filesystem layout
- swap and zram
- firewall ports
- service-local paths
- GPU quirks tied to one machine
- host-local SSH targets or values

Good fits for `modules/system/`:

- reusable service logic
- compositor plumbing
- host-agnostic package groups
- shared container runtime behavior

Good fits for `modules/home/`:

- shell aliases
- user-facing package groups
- application config
- dotfile wiring
- theme selectors

Poor fits for host modules:

- general CLI package sets
- reusable desktop package sets
- service logic that can be parameterized through `my.*`

## Desktop and Gaming Profiles

Desktop-style outputs are assembled from:

- `modules/system/cli.nix`
- `modules/system/gui-base.nix` via the compositor system module
- a compositor-specific system module
- optional system additions like gaming or Flatpak
- matching Home Manager profile modules

`gamescope` is intentionally separate from the full GUI path. It uses Steam and gamescope without `modules/system/gui-base.nix` or the larger desktop package set.

## Documentation Policy

Markdown docs are the canonical place for:

- architecture explanations
- repo workflows
- output and service reference
- “how to add/change” guidance
- modularity rules and anti-patterns

Keep docs split by purpose:

- `README.md`: short orientation and current output summary
- `docs/architecture.md`: composition model and ownership rules
- `docs/workflows.md`: change procedures
- `docs/reference.md`: current outputs, overlays, helpers, and operational reference

Prefer one canonical section per topic instead of repeating large tables across multiple files.
