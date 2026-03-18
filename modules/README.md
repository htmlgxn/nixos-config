# Modules

`modules/` contains reusable building blocks.

## Layout

- `modules/system/`: shared NixOS behavior
- `modules/home/`: shared Home Manager behavior
- `modules/shared/`: repo-local options and cross-layer glue

## Guidelines

- put reusable behavior here, not in `hosts/`
- keep module names descriptive and scoped to their layer
- use `modules/shared/my-options.nix` for repo-local values that need to cross module boundaries
- prefer short comments in module files; keep detailed explanation in Markdown docs

## Typical Split

- `modules/system/*`: services, compositor plumbing, system-wide packages, host-agnostic integration
- `modules/home/*`: user packages, dotfiles, application config, shell aliases, user-facing UX
- `modules/shared/*`: custom options or helpers shared by both NixOS and Home Manager modules
