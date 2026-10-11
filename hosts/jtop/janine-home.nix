# janine's apps on jtop: Brave, Signal, LibreOffice, pinned to the dock.
{pkgs, ...}: let
  browser = "brave-browser.desktop";
in {
  # Stable Brave from nixpkgs (boreal's nightly overlay is not applied here).
  programs.brave.enable = true;

  home.packages = with pkgs; [
    signal-desktop
    libreoffice
    hunspell
    hunspellDicts.en_CA
  ];

  dconf.settings."org/gnome/shell".favorite-apps = [
    browser
    "signal.desktop"
    "startcenter.desktop"
    "org.gnome.Nautilus.desktop"
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
