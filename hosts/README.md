# Hosts

`hosts/` is for machine-specific state and values.

Keep shared behavior out of this directory unless it is genuinely tied to one machine or one host-local value set.

Most host configs are NixOS targets, but `hosts/macbook/configuration.nix` is a nix-darwin target.

## Guidelines

- `hosts/<name>/configuration.nix` should be a thin entrypoint when the host is non-trivial
- split larger hosts into focused files such as `base.nix`, `graphics.nix`, `storage.nix`, `networking.nix`, `users.nix`, and `services.nix`
- keep generated `hardware-configuration.nix` files untouched
- prefer pushing reusable logic into shared modules and keeping only host-local values here
- use host-local Home Manager modules only when the behavior is truly host-local or value-driven
- for nix-darwin hosts, use `darwin-rebuild` workflows instead of NixOS rebuild commands

## Good Fits for Host Modules

- filesystem layout
- swap and zram
- GPU quirks tied to one machine
- local users and groups
- firewall ports
- service-local paths and storage roots
- host-local SSH targets or self-referential hostname overrides

## Poor Fits for Host Modules

- general CLI packages
- desktop package sets shared across hosts
- reusable service logic that can be parameterized through `my.*`
- heavyweight feature bundles that should be selected at the output level
