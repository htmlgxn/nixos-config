# GNOME desktop: GDM login screen plus the GNOME session, trimmed to a
# simple app set. Used by the `gnome` system profile (jtop).
{pkgs, ...}: {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Drop apps that duplicate what the user layer installs (a second browser,
  # a mail client) or that just add noise to the app grid.
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-tour
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
    gnome-connections
  ];

  # Shell extensions used by modules/home/gnome.nix (dock, tray icons).
  environment.systemPackages = with pkgs.gnomeExtensions; [
    dash-to-dock
    appindicator
  ];
  services.udev.packages = [pkgs.gnome-settings-daemon];
}
