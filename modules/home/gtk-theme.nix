# GTK theming from the shared GUI theme (my.guiTheme), for any desktop that
# runs GTK apps (GNOME, COSMIC): libadwaita CSS variables, GTK3 named colours
# on top of Adwaita-dark, icon theme and cursor. The colours live in
# themes/gui/<theme>/gnome.nix (adwaita/gtk3), shared with gnome-theme.nix.
{
  config,
  lib,
  pkgs,
  ...
}: let
  themeName = config.my.guiTheme;
  guiTheme = config.my.guiThemeData;
  theme =
    guiTheme.gnome
    or (throw "GUI theme '${themeName}' has no GTK colours (themes/gui/${themeName}/gnome.nix)");
  resolvePkg = path: builtins.foldl' (pkg: attr: pkg.${attr}) pkgs path;

  cssVars = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "  --${n}: ${v};") theme.adwaita);
  namedColors = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "@define-color ${n} ${v};") theme.gtk3);
in {
  imports = [./gui-theme.nix];

  gtk = {
    enable = true;
    colorScheme = theme.shell.base;
    theme = {
      inherit (guiTheme.gtk.gtk.theme) name;
      package = resolvePkg guiTheme.gtk.gtk.theme.package;
    };
    iconTheme = {
      inherit (guiTheme.gtk.gtk.iconTheme) name;
      package = resolvePkg guiTheme.gtk.gtk.iconTheme.package;
    };
    gtk3.extraCss = namedColors;
    # libadwaita ignores gtk-theme-name; colours come from the CSS variables.
    gtk4.theme = null;
    gtk4.extraCss = ''
      :root {
      ${cssVars}
      }
    '';
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = resolvePkg guiTheme.gtk.cursor.package;
    inherit (guiTheme.gtk.cursor) name size;
  };
}
