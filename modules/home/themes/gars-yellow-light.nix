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
    dimForeground = "#787252";
    brightForeground = "#0f0d02";

    # Cursor
    cursorText = "#fdfae8";
    cursor = "#c9aa10";

    # Vi mode cursor
    viModeCursorText = "#fdfae8";
    viModeCursor = "#6b5a0a";

    # Search
    searchMatchForeground = "#fdfae8";
    searchMatchBackground = "#9e986e";
    searchFocusedMatchForeground = "#1e1a06";
    searchFocusedMatchBackground = "#c9aa10";

    # Footer bar
    footerBarForeground = "#fdfae8";
    footerBarBackground = "#787252";

    # Hints
    hintsStartForeground = "#fdfae8";
    hintsStartBackground = "#c9aa10";
    hintsEndForeground = "#fdfae8";
    hintsEndBackground = "#8a8460";

    # Selection
    selectionText = "#1e1a06";
    selectionBackground = "#e3c220";

    # Normal color palette (0-7) — saturated
    normal = {
      black = "#1e1a06";
      red = "#b83030";
      green = "#507800";
      yellow = "#b09000";
      blue = "#1850a0";
      magenta = "#900090";
      cyan = "#007090";
      white = "#cdc79a";
    };

    # Bright color palette (8-15) — pastel
    bright = {
      black = "#48421e";
      red = "#c03030";
      green = "#5a8a00";
      yellow = "#c9aa10";
      blue = "#1a5ab0";
      magenta = "#b0005a";
      cyan = "#0080a0";
      white = "#f5f0d5";
    };

    # Indexed colors (16, 17)
    indexed = {
      "16" = "#b85010";
      "17" = "#6b5a0a";
    };
  };
}
