# Nix Workflows

This repo now exposes a dedicated Nix helper surface through `modules/home/nix-workflows.nix`. The commands are grouped by task so daily work, validation, and remote deployment stay explicit and tab-completable.

## Daily Commands

- `nflk`: open `flake.nix`
- `npath`: print repo paths used by the helpers
- `nout`: list all flake outputs grouped by `nixosConfigurations`, `darwinConfigurations`, and `homeConfigurations`
- `noutn`: list only NixOS outputs
- `noutd`: list only nix-darwin outputs
- `nouth`: list only standalone Home Manager outputs
- `nshow <output>`: show the output type and the primary installable path
- `ns [query]`: interactive `nix-search-tv` picker with `fzf` preview

## Formatting And Fast Validation

- `fnix`: format every tracked Nix file except generated hardware configs
- `fnixc`: formatting check only
- `nfmt`: alias for `fnix`
- `ncheck`: run the default fast validation set
  - `alejandra --check`
  - `nix flake check`
- `ncheck-full`: run the broader validation set
  - `ncheck`
  - evaluate all output families
  - run `deadnix` and `statix` if those commands are installed
- `ndead`: run `deadnix` on the repo
- `nstatix`: run `statix check` on the repo

## Evaluate And Build

- `neval <attr-path> [extra nix eval args]`: evaluate a repo flake attribute
- `nb <attr-path> [extra nix build args]`: build a repo flake attribute
- `nbi <installable> [extra nix build args]`: build any installable directly
- `nchk [flake-ref]`: run `nix flake check`, defaulting to this repo
- `nmeta <installable-or-attr-path>`: show store path and closure size
- `nsize <installable-or-attr-path>`: quick alias for closure size inspection
- `nwhy <installable-a> <installable-b>`: inspect why one path depends on another
- `nrepl`: open `nix repl` on the repo flake

Examples:

```bash
neval nixosConfigurations.boreal.config.networking.hostName --raw
nb nixosConfigurations.boreal.config.system.build.toplevel
nmeta nixosConfigurations.boreal.config.system.build.toplevel
```

## Local Apply Flows

These wrappers validate output names against the live flake before running the rebuild command.

### NixOS

- `nr <output>`: `nixos-rebuild switch`
- `nrb <output>`: `nixos-rebuild build`
- `nrt <output>`: `nixos-rebuild test`
- `nrd <output>`: `nixos-rebuild dry-build`
- `nrs`: shortcut for `nr boreal`
- `nrtty`: shortcut for `nr boreal-tty`
- `npre <output>`: `fnixc` then `nrd <output>`
- `nship <output>`: `npre <output>` then `nr <output>`

### nix-darwin

- `ndrs [output]`: `darwin-rebuild switch`, default `macbook`
- `ndrb [output]`: `darwin-rebuild build`, default `macbook`

### Standalone Home Manager

- `nhms [output]`: `home-manager switch`, default `fedora-arm`
- `nhmb [output]`: `home-manager build`, default `fedora-arm`

## Remote And Cross-Host Flows

These are intentionally NixOS-focused. They are the native-command answer to “build here, deploy there” without adding a separate deployment tool.

Think about remote work in three models:

### 1. Build on the target host

Use this when the target machine should do its own build work.

- `nremote-build <output> <target-host>`: ask the target host to build the output, no activation
- `nremote-test <output> <target-host>`: build on the target host and activate with `test`
- `nremote-switch <output> <target-host>`: build on the target host and fully switch

This is the simplest model when the remote host is powerful enough and already has access to the repo inputs.

Example:

```bash
nremote-build rpi4-tty pi@rpi4.local
nremote-test rpi4-tty pi@rpi4.local
```

### 2. Build locally, then send the result to the target host

Use this when your current machine should do the heavy lifting and the target host should mostly just receive the finished closure.

- `ncopy <output> <ssh-host>`: copy the output closure to the target host
- `ncopy-activate <output> <target-host>`: copy the closure, then run a remote `test` activation

This is useful when the target is slow, storage-constrained, or inconvenient to build on directly.

Typical pattern:

```bash
nrb rpi4-tty
ncopy rpi4-tty pi@rpi4.local
nremote-test rpi4-tty pi@rpi4.local
```

### 3. Build on one host for another host

Use this when neither the machine you are typing on nor the final target should necessarily do the build.

- `nboh <output> <build-host> <target-host> [build|test|switch]`: use `nixos-rebuild --build-host ... --target-host ...`
- `nship-remote <output> <build-host> <target-host>`: shortcut for the explicit remote `switch` case

This is the “real” cross-host flow:

- your current shell orchestrates
- `build-host` performs the build
- `target-host` receives and optionally activates the result

Example:

```bash
nboh rpi4-sway localhost pi@rpi4.local build
nboh rpi4-sway localhost pi@rpi4.local test
nship-remote rpi4-sway localhost pi@rpi4.local
```

## Which One Should I Use

- Use `nremote-build` if the target machine can build for itself and you just want a remote-safe dry run.
- Use `ncopy` plus `nremote-test` if you want to build locally first and keep the activation step explicit.
- Use `nboh` if you need to separate the build machine from the target machine.
- Use `nremote-switch` or `nship-remote` only when you are ready to actually change the target host.

## Important Safety Notes

- `build` means no activation.
- `test` activates the config until reboot but does not make it the default boot generation.
- `switch` activates it and makes it the new default generation.
- The helpers expect SSH access to the target host.
- For slow or fragile targets, prefer `build` or `test` first.

Examples:

```bash
nremote-build rpi4-tty pi@rpi4.local
nboh boreal-tty localhost gars@boreal.local build
nship-remote rpi4-sway localhost pi@rpi4.local
```

## Lockfile And Store Maintenance

- `nfu`: run `nix flake update`
- `nfu-input <input-name>`: update one flake input
- `nlock`: show `flake.lock` status and diff
- `nspace`: show current root and `/nix/store` disk usage
- `nspace-why`: show disk usage plus store/profile summaries and the largest store paths
- `ntop-store [count]`: show the largest `/nix/store` paths, default `20`
- `ngen-system`: list NixOS system generations
- `ngen-hm`: list Home Manager generations
- `ngen-all`: show both generation lists
- `ndiff-system [from] [to]`: diff two system generations with `nix store diff-closures`; defaults to previous vs current
- `nclean-roots`: print GC roots
- `nclean-gc`: run `nix store gc`
- `nclean-system`: delete old system and profile generations with `nix-collect-garbage -d`
- `nclean-hm [age]`: expire old Home Manager generations, default `-7 days`
- `nclean-all [age]`: run the system cleanup, optional Home Manager cleanup, then store GC

## Recommended Sequences

### Edit one module and validate it

```bash
nflk
fnix
npre boreal
```

### Validate the whole repo before committing

```bash
fnix
ncheck-full
```

### Build on one host and push to another

```bash
nboh rpi4-tty localhost pi@rpi4.local build
nremote-test rpi4-tty pi@rpi4.local
```

### Update one input and inspect the lockfile

```bash
nfu-input nixpkgs
nlock
ncheck
```

### Recover disk space after a bad update attempt

```bash
nspace
nspace-why
sudo nix-collect-garbage -d
nclean-gc
```

Or with the wrappers:

```bash
nspace
nclean-all
```

### Inspect what changed between generations

```bash
ngen-system
ndiff-system
```

If you want specific generations:

```bash
ndiff-system 123 124
```

## Platform Notes

- `nr`, `nrb`, `nrt`, `nrd`, `ncopy`, `nremote-*`, `nboh`, `ncopy-activate`, `nship`, and `nship-remote` are for NixOS outputs.
- `ndrs` and `ndrb` are for nix-darwin outputs.
- `nhms` and `nhmb` are for standalone Home Manager outputs.
- `nout*`, `npath`, `nshow`, `fnix*`, `ncheck*`, `neval`, `nb`, `nbi`, `nchk`, `nmeta`, `nwhy`, `nrepl`, `nfu*`, and `nclean-*` are cross-platform as long as the underlying commands exist.

## Why Native Nix Wrappers

This helper surface uses native `nix`, `nixos-rebuild`, `darwin-rebuild`, and `home-manager` commands instead of adding `deploy-rs` or `colmena`.

That keeps the workflows close to the repo’s explicit output model:

- one flake
- named outputs
- manual, high-clarity composition
- no second orchestration layer to keep in sync

If the repo grows into more frequent coordinated multi-host deploys, the command naming leaves room to swap some remote helpers behind the scenes later.
