#
# ~/nixos-config/modules/home/alacritty.nix
#
# Alacritty configuration managed by Home Manager.
# Colors are imported from shared terminal-theme.nix.
#
{config, ...}: let
  theme = import ./terminal-theme.nix;
in {
  programs.alacritty = {
    enable = true;
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
          background = theme.colors.background;
          foreground = theme.colors.foreground;
          dim_foreground = theme.colors.dimForeground;
          bright_foreground = theme.colors.brightForeground;
        };

        cursor = {
          text = theme.colors.cursorText;
          cursor = theme.colors.cursor;
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
          black = theme.colors.normal.black;
          red = theme.colors.normal.red;
          green = theme.colors.normal.green;
          yellow = theme.colors.normal.yellow;
          blue = theme.colors.normal.blue;
          magenta = theme.colors.normal.magenta;
          cyan = theme.colors.normal.cyan;
          white = theme.colors.normal.white;
        };

        bright = {
          black = theme.colors.bright.black;
          red = theme.colors.bright.red;
          green = theme.colors.bright.green;
          yellow = theme.colors.bright.yellow;
          blue = theme.colors.bright.blue;
          magenta = theme.colors.bright.magenta;
          cyan = theme.colors.bright.cyan;
          white = theme.colors.bright.white;
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
