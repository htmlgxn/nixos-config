#
# ~/nixos-config/modules/home/themes/gars-yellow-light.nix
#
# Terminal color theme: Yellow Light
# Warm yellow accents on light cream background.
#
{
  name = "gars-yellow-light";

  colors = {
    # Primary colors
    background = "#fdfae8";
    foreground = "#1e1a06";
    dimForeground = "#48421e";
    brightForeground = "#1e1a06";

    # Cursor
    cursorText = "#f5f0d5";
    cursor = "#c9aa10";

    # Vi mode cursor
    viModeCursorText = "#f5f0d5";
    viModeCursor = "#c9aa10";

    # Search
    searchMatchForeground = "#1e1a06";
    searchMatchBackground = "#9e986e";
    searchFocusedMatchForeground = "#1e1a06";
    searchFocusedMatchBackground = "#c9aa10";

    # Footer bar
    footerBarForeground = "#1e1a06";
    footerBarBackground = "#787252";

    # Hints
    hintsStartForeground = "#1e1a06";
    hintsStartBackground = "#c9aa10";
    hintsEndForeground = "#1e1a06";
    hintsEndBackground = "#8a8460";

    # Selection
    selectionText = "#1e1a06";
    selectionBackground = "#f5e070";

    # Normal color palette (0-7)
    normal = {
      black = "#e2dcb0";
      red = "#c03030";
      green = "#5a8a00";
      yellow = "#c9aa10";
      blue = "#1a5ab0";
      magenta = "#900090";
      cyan = "#0080a0";
      white = "#ded7b4";
    };

    # Bright color palette (8-15)
    bright = {
      black = "#d8d2a2";
      red = "#c03030";
      green = "#5a8a00";
      yellow = "#f5e070";
      blue = "#1a5ab0";
      magenta = "#b0005a";
      cyan = "#0080a0";
      white = "#48421e";
    };

    # Indexed colors (16, 17)
    indexed = {
      "16" = "#b85010";
      "17" = "#ece058";
    };
  };
}
