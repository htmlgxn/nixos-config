# The COSMIC desktop for every user on jtop (gars via home.nix, janine via
# extraHomeUsers in parts/nixos.nix): apps (Brave, Signal, Spotify, the
# ArtCraft apps), Brave as default browser, dock pins, idle settings and the
# night light settings (nightlight-home.nix).
{pkgs, ...}: let
  browser = "brave-browser.desktop";
in {
  # Stable Brave from nixpkgs (boreal's nightly overlay is not applied here),
  # with the same extensions as every other host.
  imports = [
    ../../modules/home/artcraft.nix
    ../../modules/home/brave.nix
    ../../modules/home/spicetify.nix
    ./nightlight-home.nix
  ];

  home.packages = [pkgs.signal-desktop];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
    };
  };

  wayland.desktopManager.cosmic = {
    # No idle suspend (see configuration.nix); lid close still sleeps. The
    # screen turns off after 10 minutes.
    idle = {
      screen_off_time = {
        __type = "optional";
        value = 600000;
      };
      suspend_on_ac_time = {
        __type = "optional";
        value = null;
      };
      suspend_on_battery_time = {
        __type = "optional";
        value = null;
      };
    };

    # COSMIC pins apps by desktop-entry id (the .desktop name without suffix).
    applets.app-list.settings.favorites = [
      "brave-browser"
      "signal"
      "spotify"
      "ai.storyteller.wordcraft"
      "com.system76.CosmicFiles"
    ];
  };
}
