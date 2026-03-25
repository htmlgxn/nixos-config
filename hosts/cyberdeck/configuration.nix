#
# ~/nixos-config/hosts/cyberdeck/configuration.nix
#
# jetpack-nixos module is added via extraSystemModules in flake.nix.
# Requires hardware-configuration.nix when physical hardware is acquired.
# Currently configured for NVIDIA Jetson Orin Nano (aarch64).
{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.nvidia-jetpack = {
    enable = true;
    som = "orin-nano";
    carrierBoard = "devkit";
  };

  networking.hostName = "cyberdeck";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Halifax";
  i18n.defaultLocale = "en_CA.UTF-8";

  my.primaryUser = "gars";

  users.users.gars = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    initialPassword = "changeme";
  };

  security.sudo.wheelNeedsPassword = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
