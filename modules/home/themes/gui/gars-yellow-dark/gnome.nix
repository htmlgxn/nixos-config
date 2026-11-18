#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-dark/gnome.nix
#
# GTK colours: gars-yellow-dark (libadwaita + GTK3, used by gtk-theme.nix)
#
{
  # libadwaita (GTK4) CSS variables, written to ~/.config/gtk-4.0/gtk.css.
  adwaita = {
    accent-bg-color = "#E3C220";
    accent-fg-color = "#1E1904";
    accent-color = "#EFDD84";
    window-bg-color = "#262418";
    window-fg-color = "#F6EEC9";
    view-bg-color = "#1E1904";
    view-fg-color = "#F6EEC9";
    headerbar-bg-color = "#322F1F";
    headerbar-fg-color = "#F6EEC9";
    headerbar-backdrop-color = "#262418";
    sidebar-bg-color = "#322F1F";
    sidebar-fg-color = "#F6EEC9";
    sidebar-backdrop-color = "#262418";
    secondary-sidebar-bg-color = "#2C2A1C";
    secondary-sidebar-fg-color = "#F6EEC9";
    secondary-sidebar-backdrop-color = "#262418";
    card-bg-color = "rgba(246, 238, 201, 0.06)";
    card-fg-color = "#F6EEC9";
    dialog-bg-color = "#322F1F";
    dialog-fg-color = "#F6EEC9";
    popover-bg-color = "#3B3724";
    popover-fg-color = "#F6EEC9";
    thumbnail-bg-color = "#3B3724";
    thumbnail-fg-color = "#F6EEC9";
  };

  # GTK3 Adwaita-dark named colours (GTK3 apps),
  # written to ~/.config/gtk-3.0/gtk.css.
  gtk3 = {
    theme_bg_color = "#262418";
    theme_fg_color = "#F6EEC9";
    theme_base_color = "#1E1904";
    theme_text_color = "#F6EEC9";
    theme_selected_bg_color = "#E3C220";
    theme_selected_fg_color = "#1E1904";
    insensitive_fg_color = "#5B5742";
    borders = "#826F11";
  };

  # Dark or light variant; sets gtk.colorScheme in gtk-theme.nix.
  shell.base = "dark";
}
