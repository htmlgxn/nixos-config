# Workflows

## Add a User

1. Create `modules/home/users/<username>.nix`.
2. Set user-local values such as `my.repoRoot` and `my.dotfilesRoot` there if needed.
3. Register the user in the `users` attrset in `flake.nix`.
4. Add any user-specific extra modules to `extraHomeModules`.
5. Reference the user from one or more `outputDefs` entries.

## Add a Host

1. Create `hosts/<hostname>/configuration.nix`.
2. Keep it thin if the host is non-trivial.
3. Split host-local concerns into additional files under `hosts/<hostname>/` when it improves readability.
4. Register the host in the `hosts` attrset in `flake.nix`.
5. Add one or more `outputDefs` entries for that host.

## Add a Profile

1. Add a module list to `homeProfiles` and/or `systemProfiles` in `flake.nix`.
2. Reuse existing shared modules where possible.
3. Add an `outputDefs` entry that pairs the new profile with a host and user.

## Add Packages

### CLI packages

- Shared: `modules/home/cli.nix`
- Shared container/npm tooling: `modules/home/containers.nix`
- User-specific extras: `modules/home/cli-extras.nix`
- Device/profile-specific CLI additions: `modules/home/cli-cyberdeck.nix`

### Desktop packages

- Shared desktop packages: `modules/home/gui-base.nix`
- Compositor-specific additions: the relevant file in `modules/home/`

### System packages

- Shared system baseline: `modules/system/cli.nix`
- Shared container runtime: `modules/system/containers.nix`
- Profile-specific behavior: the relevant file in `modules/system/`
- Host-only values or machine-specific settings: files under `hosts/<name>/`

## Add a Compositor

1. Create `modules/system/<compositor>.nix`.
2. Create `modules/home/<compositor>.nix`.
3. Add matching entries to `systemProfiles` and `homeProfiles`.
4. Add an output in `outputDefs`.

## Add or Change Dotfiles

- Repo-managed user dotfiles live under `home/<user>/`
- Home Manager user modules should refer to them through `config.my.dotfilesRoot` rather than hardcoded absolute paths

## Container and npm Apps

- Repo-managed container scaffolding lives under `containers/`
- Put long-running Podman services in `containers/quadlet/`
- Put compose-based projects in `containers/compose/`
- Put direct Node/npm projects in `containers/npm/`

## Service-Local Values

If a shared module needs host-specific paths or knobs:

1. Add a value to `modules/shared/my-options.nix` if it is repo-local and reused
2. Set it from the host layer
3. Read it from the shared module

`modules/system/jellyfin.nix` is the reference example for this pattern.
