# Aggregates language toolchains and development package sets.
# Host-scoped: included through a host's hostHomeModules in parts/inventory.nix
# (currently boreal only).
_: {
  imports = [
    ./go
    ./rust
    ./python
  ];
}
