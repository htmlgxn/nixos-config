#
# ~/nixos-config/modules/home/kitty.nix
#
# Kitty terminal emulator configuration managed by Home Manager.
# Styling matches alacritty.nix using shared terminal-theme.nix.
#
{config, ...}: let
  theme = config.my.terminalThemeData;
in {
  programs.kitty = {
    enable = config.my.terminal == "kitty";
    font = {
      name = "Roboto Mono";
      size = 11.0;
    };
    settings = {
      # Padding (x y)
      window_padding_width = 4;

      # Disable audio bell
      enable_audio_bell = false;

      # Colors - primary
      inherit (theme.colors) foreground;
      inherit (theme.colors) background;

      # Cursor
      inherit (theme.colors) cursor;
      cursor_text_color = theme.colors.cursorText;

      # Selection
      selection_foreground = theme.colors.selectionText;
      selection_background = theme.colors.selectionBackground;

      # Color palette - normal
      color0 = theme.colors.normal.black;
      color1 = theme.colors.normal.red;
      color2 = theme.colors.normal.green;
      color3 = theme.colors.normal.yellow;
      color4 = theme.colors.normal.blue;
      color5 = theme.colors.normal.magenta;
      color6 = theme.colors.normal.cyan;
      color7 = theme.colors.normal.white;

      # Color palette - bright
      color8 = theme.colors.bright.black;
      color9 = theme.colors.bright.red;
      color10 = theme.colors.bright.green;
      color11 = theme.colors.bright.yellow;
      color12 = theme.colors.bright.blue;
      color13 = theme.colors.bright.magenta;
      color14 = theme.colors.bright.cyan;
      color15 = theme.colors.bright.white;

      # Indexed colors (16, 17)
      color16 = theme.colors.indexed."16";
      color17 = theme.colors.indexed."17";
    };
  };
}
