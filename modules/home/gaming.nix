#
# ~/nixos-config/modules/home/gaming.nix
#
# =============================================================================
# HOME MANAGER: Gaming (Steam + gaming tools)
# =============================================================================
# Gaming user configuration.
#
# Note: gui-base.nix is imported by the parent hm config in flake.nix,
#       so this module only adds gaming-specific settings.
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
{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Gaming-related packages
    # Add gaming home packages here
  ];
}
