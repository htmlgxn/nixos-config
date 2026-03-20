#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-light/gtk.nix
#
# GTK/QT theme settings: gars-yellow-light
#
{
  gtk = {
    theme = {
      name = "Adwaita";
      package = [ "gnome-themes-extra" ];
    };
    iconTheme = {
      name = "Adwaita";
      package = [ "adwaita-icon-theme" ];
    };
  };

  qt = {
    platformTheme = "gtk";
    style = "adwaita";
  };

  cursor = {
    package = [ "catppuccin-cursors" "mochaYellow" ];
    name = "Catppuccin-Mocha-Yellow-Cursors";
    size = 26;
  };
}
