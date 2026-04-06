# Workflows

For shell helpers and command combos, see [`docs/nix-workflows.md`](nix-workflows.md).

## Add a User

1. Create `modules/home/users/<username>.nix`.
2. Import `modules/home/users/common.nix` if the user should inherit the shared shell/editor/theme baseline.
3. Set user-local values such as `my.repoRoot`, `my.dotfilesRoot`, `my.dotfilesNixPath`, and `my.containersRoot`.
4. Set `my.isNixOS = false` in non-NixOS user modules.
5. Register the user in the `users` attrset in `flake.nix`.
6. Keep user-specific logic in the user module itself; if the extra behavior is optional, reusable, or output-specific, model it as an explicit home overlay group instead.
7. Reference the user from one or more output maps.

Rule of thumb: user definitions should describe the user, not silently expand unrelated outputs.

## Add a Host

1. Create `hosts/<hostname>/configuration.nix`.
2. Keep it thin if the host is non-trivial.
3. Split host-local concerns into focused files under `hosts/<hostname>/` when that improves readability or ownership clarity.
4. Register the host in the `hosts` attrset in `flake.nix`.
5. Add `extraSystemModules` only for shared modules that are still host-scoped by values or hardware.
6. Add `hostHomeModules` only for host-local Home Manager behavior or values that do not belong in shared profiles.
7. Add one or more `nixosOutputDefs` entries for that host.

## Add a Profile

1. Add a module list to `homeProfiles` and/or `systemProfiles` in `flake.nix`.
2. Reuse existing shared modules where possible.
3. Keep profiles capability-oriented: TTY, Sway, gaming, lean ARM desktop, and so on.
4. Add output entries in the relevant map:
   - `nixosOutputDefs` for NixOS
   - `darwinOutputDefs` for nix-darwin
   - `homeOutputDefs` for standalone Home Manager

If a capability is optional and heavyweight, prefer making it an explicit overlay group instead of hiding it inside an otherwise general profile.

## Add an Output Definition

Create the output by selecting parts in this order:

1. choose the host
2. choose the user
3. choose the system profile
4. choose the home profile
5. add only the overlay groups the output actually needs

The target is that a new output should not require discovering unrelated implicit behavior elsewhere in the repo.

## Add Packages

### CLI packages

- Shared baseline: `modules/home/cli.nix`
- Optional AI tooling: `modules/home/ai-cli-agents.nix`, `modules/home/ai-cli-opencode.nix`, `modules/home/ai-cli-extras.nix`, `modules/home/ai-cli-orchestrators.nix`, `modules/home/ai-ollama.nix`, and `modules/home/ai-ollama-rocm.nix`
- Shared container/npm tooling: `modules/home/containers.nix`
- Output-level optional extras: explicit home overlay groups in `flake.nix`
- Device/profile-specific CLI additions: place in a dedicated module and add to the relevant home profile

### Desktop packages

- Shared desktop packages: `modules/home/gui-base.nix`
- Heavier desktop extras: `modules/home/gui-extras.nix`
- Compositor-specific additions: the relevant file in `modules/home/`

### System packages

- Shared system baseline: `modules/system/cli.nix`
- Shared container runtime: `modules/system/containers.nix`
- Profile-specific behavior: the relevant file in `modules/system/`
- Host-only values or machine-specific settings: files under `hosts/<name>/`

## Add a Compositor

1. Create `modules/system/<compositor>.nix` and import `./gui-base.nix` there if it is a full desktop path.
2. Create `modules/home/<compositor>.nix`.
3. Add matching entries to `systemProfiles` and `homeProfiles`.
4. Add an output in `nixosOutputDefs`.
5. Document whether the compositor is intended to be lean, full-desktop, or both.

## Add or Change Dotfiles

- Repo-managed user dotfiles live under `home/<user>/`
- Home Manager user modules should refer to them through `config.my.dotfilesRoot` or `config.my.dotfilesNixPath` rather than hardcoded absolute paths

## Add or Change Service-Local Values

If a shared module needs host-specific paths or knobs:

1. add a value to `modules/shared/options.nix` if it is repo-local and reused
2. set it from the host layer
3. read it from the shared module

`modules/system/jellyfin.nix` is the reference example for this pattern.

## Container and npm Apps

- Repo-managed container scaffolding lives under `containers/`
- Put long-running Podman services in `containers/quadlet/`
- Put compose-based projects in `containers/compose/`
- Put direct Node/npm projects in `containers/npm/`

## Before Finishing a Change

Check for avoidable modularity regressions:

- is behavior reusable but trapped in a host file
- is a host-local value hardcoded in a shared module
- is a heavyweight feature included by default when it could be opt-in
- does adding a new output require changing multiple unrelated inventories or helper lists
