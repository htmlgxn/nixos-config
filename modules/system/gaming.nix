#
# ~/nixos-config/modules/system/gaming.nix
#
# =============================================================================
# SYSTEM CONFIGURATION: Gaming (Steam + gaming tools)
# =============================================================================
# Gaming platform system configuration.
#
# Requires: hardware.graphics.enable and enable32Bit (set in boreal/configuration.nix)
#
# TO ADD GAMING PACKAGES:
#   Add to environment.systemPackages below
#
# Examples:
#   - pkgs.steamtinkerlaunch - Steam game launcher tool
#   - pkgs.gamescope - Micro-compositor for games
#   - pkgs.mangoapp - Gaming overlay (MangoHud)
#   - pkgs.lutris - Game launcher (non-Steam games)
#   - pkgs.heroic - Epic Games launcher
#
# Home Manager module: modules/home/gaming.nix
# =============================================================================
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Steam platform
  programs.steam = {
    enable = true;

    # Enable remote play (streaming to other devices)
    remotePlay.openFirewall = true;

    # Enable Steam Play (Proton) for all games
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    steam
    # Add more gaming packages here
  ];
}
