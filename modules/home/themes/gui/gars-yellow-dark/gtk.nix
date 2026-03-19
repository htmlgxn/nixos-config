#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-dark/gtk.nix
#
# GTK/QT theme settings: gars-yellow-dark
#
{
  gtk = {
    theme = {
      name = "Adwaita-dark";
      package = [ "gnome-themes-extra" ];
    };
    iconTheme = {
      name = "Adwaita";
      package = [ "adwaita-icon-theme" ];
    };
  };

  qt = {
    platformTheme = "gtk";
    style = "adwaita-dark";
  };

  cursor = {
    package = [ "catppuccin-cursors" "mochaYellow" ];
    name = "Catppuccin-Mocha-Yellow-Cursors";
    size = 26;
  };
}
