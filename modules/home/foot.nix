#
# ~/nixos-config/modules/home/foot.nix
#
# Foot terminal emulator configuration managed by Home Manager.
# Styling uses shared terminal-theme.nix (same source as kitty.nix).
#
{
  config,
  lib,
  ...
}: let
  theme = config.my.terminalThemeData;
  # Foot uses RRGGBB without the '#' prefix
  strip = s: lib.removePrefix "#" s;
in {
  programs.foot = {
    enable = config.my.terminal == "foot";
    settings = {
      main = {
        font = "Roboto Mono:size=${toString config.my.terminalFontSize}";
        pad = "4x4";
      };

      bell = {
        urgent = "no";
        notify = "no";
      };

      colors = {
        foreground = strip theme.colors.foreground;
        background = strip theme.colors.background;

        regular0 = strip theme.colors.normal.black;
        regular1 = strip theme.colors.normal.red;
        regular2 = strip theme.colors.normal.green;
        regular3 = strip theme.colors.normal.yellow;
        regular4 = strip theme.colors.normal.blue;
        regular5 = strip theme.colors.normal.magenta;
        regular6 = strip theme.colors.normal.cyan;
        regular7 = strip theme.colors.normal.white;

        bright0 = strip theme.colors.bright.black;
        bright1 = strip theme.colors.bright.red;
        bright2 = strip theme.colors.bright.green;
        bright3 = strip theme.colors.bright.yellow;
        bright4 = strip theme.colors.bright.blue;
        bright5 = strip theme.colors.bright.magenta;
        bright6 = strip theme.colors.bright.cyan;
        bright7 = strip theme.colors.bright.white;

        selection-foreground = strip theme.colors.selectionText;
        selection-background = strip theme.colors.selectionBackground;
      };

      cursor = {
        color = "${strip theme.colors.cursorText} ${strip theme.colors.cursor}";
      };
    };
  };
}
