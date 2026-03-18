#
# ~/nixos-config/modules/home/gaming.nix
#
# =============================================================================
# HOME MANAGER: Gaming (Steam + gaming tools)
# =============================================================================
# Gaming user configuration.
#
# This module is intentionally lightweight so it can be reused by both:
#   - full desktop profiles (for example Sway + gaming)
#   - minimal profiles (for example gamescope without gui-base.nix)
#
# TO ADD GAMING HOME PACKAGES:
#   Add to home.packages below
#
# Examples:
#   - pkgs.protontricks - Proton configuration tool
#   - pkgs.lutris - Game launcher (non-Steam games)
#   - pkgs.heroic - Epic Games launcher
#   - pkgs.gamescope - Micro-compositor for games
#
# System module: modules/system/gaming.nix
# =============================================================================
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Gaming-related packages
    # Add gaming home packages here
  ];
}
