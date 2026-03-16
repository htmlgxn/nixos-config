#
# ~/nixos-config/modules/home/packages/default.nix
#
{...}: {
  imports = [
    ./go
    ./rust
    ./python
  ];
}
