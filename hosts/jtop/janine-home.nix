# janine's apps on jtop (both desktops): Brave, Signal, Spotify, LibreOffice.
# Dock pins are per desktop: janine-gnome.nix / janine-cosmic.nix.
{pkgs, ...}: let
  browser = "brave-browser.desktop";
in {
  # Stable Brave from nixpkgs (boreal's nightly overlay is not applied here),
  # with the same extensions as every other host.
  imports = [
    ../../modules/home/brave.nix
    ../../modules/home/spicetify.nix
  ];

  home.packages = with pkgs; [
    signal-desktop
    libreoffice
    hunspell
    hunspellDicts.en_CA
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
    };
  };
}
