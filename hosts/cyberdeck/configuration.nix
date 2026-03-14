{ config, pkgs, lib, ... }:

# Note: Requires hardware-configuration.nix when physical hardware is acquired.
# Currently configured for NVIDIA Jetson Orin Nano (aarch64).

{
  hardware.nvidia-jetpack = {
    enable = true;
    som = "orin-nano-16gb";    # change to orin-nano-16gb if that's your variant
    carrierBoard = "devkit";
  };

  networking.hostName = "cyberdeck";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Halifax";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.gars = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };

  security.sudo.wheelNeedsPassword = true;

  # Enable cross-compilation from x86 desktop
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "25.11";
}
