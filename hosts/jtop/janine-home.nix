# janine's apps on jtop: Brave, Signal, Spotify, the ArtCraft apps.
# Dock pins live in janine-cosmic.nix.
{pkgs, ...}: let
  browser = "brave-browser.desktop";
in {
  # Stable Brave from nixpkgs (boreal's nightly overlay is not applied here),
  # with the same extensions as every other host.
  imports = [
    ../../modules/home/artcraft.nix
    ../../modules/home/brave.nix
    ../../modules/home/spicetify.nix
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
}
