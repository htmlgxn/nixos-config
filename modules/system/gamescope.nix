#
# ~/nixos-config/modules/system/gamescope.nix
#
# =============================================================================
# SYSTEM CONFIGURATION: Gamescope (minimal Steam session)
# =============================================================================
# Minimal gamescope-based session for launching Steam without the full desktop
# package set used by the regular GUI profiles.
#
# Requires:
#   - modules/system/gaming.nix (for Steam itself)
#   - graphics support from the host configuration
#
# Home Manager companion: modules/home/gaming.nix
# =============================================================================
#
{pkgs, ...}: {
  security.rtkit.enable = true;

  services.greetd.enable = true;
  services.greetd.settings.default_session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --cmd steam-gamescope";
    user = "greeter";
  };

  programs.gamescope.capSysNice = true;
  programs.steam.gamescopeSession.enable = true;
}
