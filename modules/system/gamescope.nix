# Minimal gamescope session for Steam-focused profiles.
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
