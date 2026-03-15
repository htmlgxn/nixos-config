#
# ~/nixos-config/modules/home/alacritty.nix
#
# Alacritty configuration managed by Home Manager.
#

{ config, ... }:

{
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
        padding = { x = 4; y = 4; };
      };

      colors = {
        primary = {
          background = "#1e1904";
          foreground = "#f6eec9";
          dim_foreground = "#a29c7f";
          bright_foreground = "#fcf9e8";
        };

        cursor = {
          text = "#3b3724";
          cursor = "#efdd84";
        };

        vi_mode_cursor = {
          text = "#3b3724";
          cursor = "#e3c220";
        };

        search = {
          matches = {
            foreground = "#1e1904";
            background = "#b7b193";
          };
          focused_match = {
            foreground = "#1e1904";
            background = "#e3c220";
          };
        };

        footer_bar = {
          foreground = "#1e1904";
          background = "#b7b193";
        };

        hints = {
          start = {
            foreground = "#1e1904";
            background = "#e3c220";
          };
          end = {
            foreground = "#1e1904";
            background = "#a29c7f";
          };
        };

        selection = {
          text = "#1e1904";
          background = "#efdd84";
        };

        normal = {
          black = "#322f1f";
          red = "#ef8484";
          green = "#e4ef84";
          yellow = "#e3c220";
          blue = "#84baef";
          magenta = "#f4b8e4";
          cyan = "#84e0ef";
          white = "#ded7b4";
        };

        bright = {
          black = "#3b3724";
          red = "#ef8484";
          green = "#e4ef84";
          yellow = "#efdd84";
          blue = "#84baef";
          magenta = "#ef84ac";
          cyan = "#84e0ef";
          white = "#cbc4a3";
        };

        indexed_colors = [
          {
            index = 16;
            color = "#ef9f76";
          }
          {
            index = 17;
            color = "#f8ebac";
          }
        ];
      };
    };
  };
}
