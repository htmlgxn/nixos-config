# Modules

`modules/` contains reusable building blocks.

## Layout

- `modules/system/`: shared system behavior (primarily NixOS modules)
- `modules/home/`: shared Home Manager behavior
- `modules/shared/`: repo-local options and cross-layer glue

## Guidelines

- put reusable behavior here, not in `hosts/`
- keep module names descriptive and scoped to their layer
- use `modules/shared/my-options.nix` for repo-local values that need to cross module boundaries
- prefer short comments in module files; keep detailed explanation in Markdown docs
- keep optional heavyweight module groups (for example `modules/home/ai-agents.nix`) separate and include them through output-level `extraHomeModules`

## Typical Split

- `modules/system/*`: services, compositor plumbing, system-wide packages, host-agnostic integration
- `modules/home/*`: user packages, dotfiles, application config, shell aliases, user-facing UX
- `modules/shared/*`: custom options or helpers shared by both NixOS and Home Manager modules

## User Module Pattern

- put shared user shell/editor/theme logic in `modules/home/users/<name>-common.nix`
- import that common module from platform-specific user modules (for example `gars.nix` and `htmlgxn.nix`)
