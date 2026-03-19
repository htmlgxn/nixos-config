#
# ~/nixos-config/modules/home/kitty.nix
#
# Kitty terminal emulator configuration managed by Home Manager.
# Styling matches alacritty.nix as closely as possible.
#
{config, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Roboto Mono";
      size = 11.0;
    };
    settings = {
      # Padding (x y)
      window_padding_width = 4;

      # Colors - primary
      foreground = "#f6eec9";
      background = "#1e1904";

      # Cursor
      cursor = "#efdd84";
      cursor_text_color = "#3b3724";

      # Selection
      selection_foreground = "#1e1904";
      selection_background = "#efdd84";

      # Color palette - normal
      color0 = "#322f1f"; # black
      color1 = "#ef8484"; # red
      color2 = "#e4ef84"; # green
      color3 = "#e3c220"; # yellow
      color4 = "#84baef"; # blue
      color5 = "#f4b8e4"; # magenta
      color6 = "#84e0ef"; # cyan
      color7 = "#ded7b4"; # white

      # Color palette - bright
      color8 = "#3b3724"; # bright black
      color9 = "#ef8484"; # bright red
      color10 = "#e4ef84"; # bright green
      color11 = "#efdd84"; # bright yellow
      color12 = "#84baef"; # bright blue
      color13 = "#ef84ac"; # bright magenta
      color14 = "#84e0ef"; # bright cyan
      color15 = "#cbc4a3"; # bright white

      # Indexed colors (16, 17)
      color16 = "#ef9f76";
      color17 = "#f8ebac";
    };
  };
}
