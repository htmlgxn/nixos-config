#
# ~/nixos-config/modules/home/themes/gars-yellow-dark.nix
#
# Terminal color theme: Yellow Dark
# Warm yellow accents on dark brown-black background.
#
{
  name = "gars-yellow-dark";

  colors = {
    # Primary colors
    background = "#1e1904";
    foreground = "#f6eec9";
    dimForeground = "#a29c7f";
    brightForeground = "#fcf9e8";

    # Cursor
    cursorText = "#3b3724";
    cursor = "#efdd84";

    # Vi mode cursor
    viModeCursorText = "#3b3724";
    viModeCursor = "#e3c220";

    # Search
    searchMatchForeground = "#1e1904";
    searchMatchBackground = "#b7b193";
    searchFocusedMatchForeground = "#1e1904";
    searchFocusedMatchBackground = "#e3c220";

    # Footer bar
    footerBarForeground = "#1e1904";
    footerBarBackground = "#b7b193";

    # Hints
    hintsStartForeground = "#1e1904";
    hintsStartBackground = "#e3c220";
    hintsEndForeground = "#1e1904";
    hintsEndBackground = "#a29c7f";

    # Selection
    selectionText = "#1e1904";
    selectionBackground = "#efdd84";

    # Normal color palette (0-7) — saturated
    normal = {
      black = "#322f1f";
      red = "#e06060";
      green = "#b8d840";
      yellow = "#e3c220";
      blue = "#5298e0";
      magenta = "#d460c0";
      cyan = "#40c0d8";
      white = "#ded7b4";
    };

    # Bright color palette (8-15) — pastel
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

    # Indexed colors (16, 17)
    indexed = {
      "16" = "#e08850";
      "17" = "#f8ebac";
    };
  };
}
