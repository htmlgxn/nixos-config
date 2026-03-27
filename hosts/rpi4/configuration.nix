# Raspberry Pi 4 NixOS host configuration.
# nixos-hardware module is added via extraSystemModules in flake.nix.
# Generate hardware-configuration.nix after initial install:
#   nixos-generate-config --show-hardware-config > hosts/rpi4/hardware-configuration.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix # uncomment after generating on hardware
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = lib.mkForce "yes";
  };

  # RPi4 uses U-Boot via extlinux
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "rpi4";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [2200];

  my.primaryUser = "gars";

  users.users.gars = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio"];
    initialPassword = "changeme";
  };

  nix.settings.trusted-users = ["root" "gars"];

  system.stateVersion = "25.11";
}
