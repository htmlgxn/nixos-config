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

  time.timeZone = "America/Halifax";
  i18n.defaultLocale = "en_CA.UTF-8";

  my.primaryUser = "gars";
  my.networkInterface = "eth0";

  users.users.gars = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio"];
    initialPassword = "changeme";
  };

  nix.settings.trusted-users = ["root" "gars"];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "25.11";
}
