# Hosts

`hosts/` is for machine-specific state and values.

Keep shared behavior out of this directory unless it is genuinely tied to one machine.

## Guidelines

- `hosts/<name>/configuration.nix` should be a thin entrypoint when the host is non-trivial
- split large hosts into focused files such as `base.nix`, `graphics.nix`, `storage.nix`, `networking.nix`, `users.nix`, and `services.nix`
- keep generated `hardware-configuration.nix` files untouched
- prefer pushing reusable logic into `modules/system/` and keeping only host-local values here

## Good Fits for Host Modules

- filesystem layout
- swap and zram
- GPU quirks tied to one machine
- local users and groups
- firewall ports
- service-local paths and storage roots

## Poor Fits for Host Modules

- general CLI packages
- desktop package sets shared across hosts
- reusable service logic that can be parameterized through `my.*`
