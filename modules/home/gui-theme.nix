#
# ~/nixos-config/modules/home/gui-theme.nix
#
# GUI theme selector module.
# Select a theme via my.guiTheme option (e.g., "gars-yellow-dark").
# Available themes are in ./themes/gui/ directory.
#
{
  lib,
  config,
  ...
}: let
  # Available themes in ./themes/gui/
  availableThemes = {
    "gars-yellow-dark" = {
      fuzzel = import ./themes/gui/gars-yellow-dark/fuzzel.nix;
      mako = import ./themes/gui/gars-yellow-dark/mako.nix;
      sway = import ./themes/gui/gars-yellow-dark/sway.nix;
      niri = import ./themes/gui/gars-yellow-dark/niri.nix;
      waybar = import ./themes/gui/gars-yellow-dark/waybar.nix;
      gtk = import ./themes/gui/gars-yellow-dark/gtk.nix;
    };
    # Add more themes here:
    # "catppuccin-mocha" = {
    #   fuzzel = import ./themes/gui/catppuccin-mocha/fuzzel.nix;
    #   mako = import ./themes/gui/catppuccin-mocha/mako.nix;
    #   sway = import ./themes/gui/catppuccin-mocha/sway.nix;
    #   niri = import ./themes/gui/catppuccin-mocha/niri.nix;
    #   waybar = import ./themes/gui/catppuccin-mocha/waybar.nix;
    #   gtk = import ./themes/gui/catppuccin-mocha/gtk.nix;
    # };
    # "gruvbox-dark" = {
    #   fuzzel = import ./themes/gui/gruvbox-dark/fuzzel.nix;
    #   mako = import ./themes/gui/gruvbox-dark/mako.nix;
    #   sway = import ./themes/gui/gruvbox-dark/sway.nix;
    #   niri = import ./themes/gui/gruvbox-dark/niri.nix;
    #   waybar = import ./themes/gui/gruvbox-dark/waybar.nix;
    #   gtk = import ./themes/gui/gruvbox-dark/gtk.nix;
    # };
  };

  cfg = config.my.guiTheme;
  selectedTheme = availableThemes.${cfg};
in {
  options.my.guiThemeData = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    description = "Selected GUI theme data";
  };

  config = lib.mkIf (selectedTheme != null) {
    my.guiThemeData = selectedTheme;
  };
}
