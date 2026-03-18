# Thin boreal host entrypoint; host-local structure is documented in hosts/README.md.
{...}: {
  imports = [
    ./hardware-configuration.nix
    ./base.nix
    ./graphics.nix
    ./storage.nix
    ./networking.nix
    ./users.nix
    ./services.nix
  ];

  # See: https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.11";
}
