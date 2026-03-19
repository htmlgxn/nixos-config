# Terminal Themes

Available terminal color themes for alacritty and kitty.

## Adding a New Theme

1. Create a new file in this directory (e.g., `catppuccin-mocha.nix`)
2. Copy the structure from an existing theme
3. Update the color values
4. Register it in `../terminal-theme.nix`

## Theme Structure

```nix
{
  name = "theme-name";

  colors = {
    # Primary colors
    background = "#000000";
    foreground = "#ffffff";
    dimForeground = "#888888";
    brightForeground = "#ffffff";

    # Cursor
    cursorText = "#000000";
    cursor = "#ffffff";

    # Vi mode cursor
    viModeCursorText = "#000000";
    viModeCursor = "#ffff00";

    # Search
    searchMatchForeground = "#000000";
    searchMatchBackground = "#aaaaaa";
    searchFocusedMatchForeground = "#000000";
    searchFocusedMatchBackground = "#ffff00";

    # Footer bar
    footerBarForeground = "#000000";
    footerBarBackground = "#aaaaaa";

    # Hints
    hintsStartForeground = "#000000";
    hintsStartBackground = "#ffff00";
    hintsEndForeground = "#000000";
    hintsEndBackground = "#888888";

    # Selection
    selectionText = "#000000";
    selectionBackground = "#ffffff";

    # Normal color palette (0-7)
    normal = {
      black = "#000000";
      red = "#ff0000";
      green = "#00ff00";
      yellow = "#ffff00";
      blue = "#0000ff";
      magenta = "#ff00ff";
      cyan = "#00ffff";
      white = "#ffffff";
    };

    # Bright color palette (8-15)
    bright = {
      black = "#444444";
      red = "#ff0000";
      green = "#00ff00";
      yellow = "#ffff00";
      blue = "#0000ff";
      magenta = "#ff00ff";
      cyan = "#00ffff";
      white = "#ffffff";
    };

    # Indexed colors (16, 17)
    indexed = {
      "16" = "#ff8800";
      "17" = "#ffcc66";
    };
  };
}
```

## Available Themes

- `gars-yellow-dark` - Warm yellow accents on dark brown-black background
