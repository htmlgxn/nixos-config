# Repository Guidelines

## Project Structure & Module Organization
- `flake.nix` defines all NixOS and Home Manager outputs. Host targets include `boreal`, `boreal-niri`, and `nixos-vm`.
- `hosts/<name>/configuration.nix` contains per-host system settings.
- `hosts/<name>/hardware-configuration.nix` is generated; do not edit it manually or via automation.
- `modules/system/*.nix` holds reusable system modules (CLI base, window-manager specific modules).
- `modules/home/*.nix` holds Home Manager modules (CLI, GUI base, Sway/Niri, Waybar, app configs).
- `modules/home/cli-extras.nix` is for experimental or host-specific CLI packages; enable it per host by adding `hmExtras` in `flake.nix`.
- `home/gars/home.nix` is the primary Home Manager entrypoint for user `gars`.
- `home/gars/dots/` and `home/gars/nvim/` contain dotfiles and editor configuration referenced by Home Manager.

## Build, Test, and Development Commands
- These commands are for the human operator only. Agents must not run rebuilds or switch operations.
- `sudo nixos-rebuild switch --flake .#boreal` applies the production Sway configuration.
- `sudo nixos-rebuild switch --flake .#boreal-niri` applies the Niri variant.
- `sudo nixos-rebuild switch --flake .#nixos-vm` applies the VM target.
- `sudo nixos-rebuild build --flake .#<host>` evaluates and builds without switching (safe check).
- `nix flake update` refreshes `flake.lock` inputs.
- Aliases like `nrs`, `nrn`, `nrsg` are defined in `home/gars/home.nix` for convenience.

## Coding Style & Naming Conventions
- Use 2-space indentation and align braces with existing Nix style.
- Prefer lower-case, hyphenated filenames (for example `gui-base.nix`, `waybar-settings.nix`).
- Keep module names descriptive and scoped to their layer: `modules/system/<feature>.nix` vs `modules/home/<feature>.nix`.
- Keep host names stable; they are referenced directly in `flake.nix` output keys.
- Format Nix with `alejandra`.
- Format all Nix files except hardware configs:
- `rg --files -g '*.nix' -g '!hosts/*/hardware-configuration.nix' | xargs alejandra`

## Testing Guidelines
- There are no automated tests in this repository.
- Validate changes by building the target: `sudo nixos-rebuild build --flake .#boreal`.
- For GUI changes (Waybar/Sway/Niri), do a local switch and visually confirm behavior.

## Agent-Specific Instructions
- Agents must not run `nixos-rebuild` or perform switch/build actions.
- Agents must never edit `hosts/*/hardware-configuration.nix`.

## Commit Guidelines
- Commit history uses short, descriptive, lower-case sentences, sometimes with iteration notes (for example `moved sway config to modules/home/sway.nix - test 3`).
- Keep commit messages specific to the module or host being changed.
