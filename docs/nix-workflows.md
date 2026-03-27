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

- `ncopy <output> <ssh-host>`: copy the built system closure to a remote machine
- `nremote-build <output> <target-host>`: build the target output on the remote host without switching
- `nremote-test <output> <target-host>`: remote `test` activation
- `nremote-switch <output> <target-host>`: remote `switch` activation
- `nboh <output> <build-host> <target-host> [build|test|switch]`: build on one host and deploy or test on another using `--build-host` and `--target-host`
- `ncopy-activate <output> <target-host>`: copy the closure, then run a remote `test` activation
- `nship-remote <output> <build-host> <target-host>`: explicit build-host plus remote `switch`

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
- `nclean-roots`: print GC roots
- `nclean-gc`: run `nix store gc`

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
