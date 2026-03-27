# Modules

`modules/` contains reusable building blocks.

## Layout

- `modules/system/`: shared system behavior, primarily NixOS modules
- `modules/home/`: shared Home Manager behavior
- `modules/shared/`: repo-local options and cross-layer glue

## Guidelines

- put reusable behavior here, not in `hosts/`
- keep module names descriptive and scoped to their layer
- use `modules/shared/options.nix` for repo-local values that need to cross module boundaries
- keep optional heavyweight module groups separate and select them explicitly from output definitions
- keep detailed explanation in Markdown docs instead of long Nix file comments

## Typical Split

- `modules/system/*`: services, compositor plumbing, system-wide packages, host-agnostic integration
- `modules/home/*`: user packages, dotfiles, application config, shell aliases, user-facing UX
- `modules/home/nix-workflows.nix`: shared shell helpers for evaluation, rebuilds, remote deploys, and repo validation
- `modules/shared/*`: custom options or helpers shared by both NixOS and Home Manager modules

## User Module Pattern

- `modules/home/users/common.nix` is the shared user baseline for shell, SSH, editor, and theme behavior
- platform-specific user modules such as `gars.nix` and `htmlgxn.nix` import that baseline and provide host/platform paths and overrides

## Modularity Rules

- profiles should express capabilities, not one-off machines
- host modules should supply values and narrow behavior, not silent shared feature bundles
- if a shared module needs a repo-local value, thread it through `my.*`
- if an output needs extra weight, make that opt-in and visible at the output definition
