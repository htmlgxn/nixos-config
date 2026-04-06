#
# ~/nixos-config/modules/home/alacritty.nix
#
# Alacritty configuration managed by Home Manager.
# Colors are imported from shared terminal-theme.nix.
#
{config, ...}: let
  theme = config.my.terminalThemeData;
in {
  programs.alacritty = {
    enable = config.my.terminal == "alacritty";
    settings = {
      font = {
        size = 11.0;
        normal = {
          family = "Roboto Mono";
          style = "Regular";
        };
        bold = {
          family = "Roboto Mono";
          style = "Bold";
        };
        italic = {
          family = "Roboto Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "Roboto Mono";
          style = "Bold Italic";
        };
      };

      window = {
        padding = {
          x = 4;
          y = 4;
        };
      };

      colors = {
        primary = {
          inherit (theme.colors) background;
          inherit (theme.colors) foreground;
          dim_foreground = theme.colors.dimForeground;
          bright_foreground = theme.colors.brightForeground;
        };

        cursor = {
          text = theme.colors.cursorText;
          inherit (theme.colors) cursor;
        };

        vi_mode_cursor = {
          text = theme.colors.viModeCursorText;
          cursor = theme.colors.viModeCursor;
        };

        search = {
          matches = {
            foreground = theme.colors.searchMatchForeground;
            background = theme.colors.searchMatchBackground;
          };
          focused_match = {
            foreground = theme.colors.searchFocusedMatchForeground;
            background = theme.colors.searchFocusedMatchBackground;
          };
        };

        footer_bar = {
          foreground = theme.colors.footerBarForeground;
          background = theme.colors.footerBarBackground;
        };

        hints = {
          start = {
            foreground = theme.colors.hintsStartForeground;
            background = theme.colors.hintsStartBackground;
          };
          end = {
            foreground = theme.colors.hintsEndForeground;
            background = theme.colors.hintsEndBackground;
          };
        };

        selection = {
          text = theme.colors.selectionText;
          background = theme.colors.selectionBackground;
        };

        normal = {
          inherit (theme.colors.normal) black;
          inherit (theme.colors.normal) red;
          inherit (theme.colors.normal) green;
          inherit (theme.colors.normal) yellow;
          inherit (theme.colors.normal) blue;
          inherit (theme.colors.normal) magenta;
          inherit (theme.colors.normal) cyan;
          inherit (theme.colors.normal) white;
        };

        bright = {
          inherit (theme.colors.bright) black;
          inherit (theme.colors.bright) red;
          inherit (theme.colors.bright) green;
          inherit (theme.colors.bright) yellow;
          inherit (theme.colors.bright) blue;
          inherit (theme.colors.bright) magenta;
          inherit (theme.colors.bright) cyan;
          inherit (theme.colors.bright) white;
        };

        indexed_colors = [
          {
            index = 16;
            color = theme.colors.indexed."16";
          }
          {
            index = 17;
            color = theme.colors.indexed."17";
          }
        ];
      };
    };
  };
}
