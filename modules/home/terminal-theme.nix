#
# ~/nixos-config/modules/home/terminal-theme.nix
#
# Terminal theme selector module.
# Select a theme via my.terminalTheme option (e.g., "gars-yellow-dark").
# Available themes are in ./themes/ directory.
#
{
  lib,
  config,
  ...
}: let
  # Available themes in ./themes/
  availableThemes = {
    "gars-yellow-dark" = import ./themes/gars-yellow-dark.nix;
    # Add more themes here:
    # "catppuccin-mocha" = import ./themes/catppuccin-mocha.nix;
    # "gruvbox-dark" = import ./themes/gruvbox-dark.nix;
  };

  cfg = config.my.terminalTheme;
  selectedTheme = availableThemes.${cfg};
in {
  options.my.terminalThemeData = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    description = "Selected terminal theme data";
  };

  config = lib.mkIf (selectedTheme != null) {
    my.terminalThemeData = selectedTheme;
  };
}
