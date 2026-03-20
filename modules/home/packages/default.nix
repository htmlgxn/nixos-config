# Aggregates language toolchains and development package sets.
# Included in all Home Manager profiles via sharedHomeModules in flake.nix.
{...}: {
  imports = [
    ./go
    ./rust
    ./python
  ];
}
