# GUI Themes

Modular theme definitions for GUI applications (Sway, Waybar, Mako, Fuzzel, GTK).

## Structure

Themes are organized by theme name with subdirectories for each application:

```
gui/
  gars-yellow-dark/
    sway.nix    - Sway window manager colors
    waybar.nix  - Waybar status bar CSS and colors
    mako.nix    - Mako notification daemon colors
    fuzzel.nix  - Fuzzel launcher colors
    gtk.nix     - GTK/QT theme and cursor settings
    gnome.nix   - GNOME colours: libadwaita variables, GTK3 named colours,
                  GNOME Shell accent + grey ramp (optional; dark only so far)
```

## Adding a New Theme

1. Create a new directory under `gui/` (e.g., `gui/catppuccin-mocha/`)
2. Create theme files for each application you want to theme
3. Register the theme in `../gui-theme.nix`

## Theme File Formats

### sway.nix

```nix
{
  colors = {
    focused = {
      border = "#E3C220";
      background = "#3B3724";
      text = "#F6EEC9";
      indicator = "#EFDD84";
      childBorder = "#E3C220";
    };
    focusedInactive = { ... };
    unfocused = { ... };
    urgent = { ... };
    background = "#1E1904";
  };

  seat = {
    xcursor-theme = "catppuccin-mocha-yellow-cursors 26";
  };
}
```

### waybar.nix

```nix
{
  css = ''
    * {
        font-family: "Roboto Mono";
    }
    window#waybar {
        background-color: #262418;
        color: #F6EEC9;
    }
    /* ... more CSS with actual hex colors ... */
  '';
}
```

### mako.nix

```nix
{
  default = {
    background-color = "#262418";
    text-color = "#F6EEC9";
    border-color = "#826F11";
    progress-color = "over #E3C220";
  };

  urgency = {
    low = { ... };
    normal = { ... };
    high = { ... };
    hidden = { ... };
  };
}
```

### fuzzel.nix

```nix
{
  colors = {
    background = "262418ff";
    border = "826F11ff";
    text = "F6EEC9ff";
    prompt = "A29C7Fff";
    placeholder = "5B5742ff";
    input = "F6EEC9ff";
    match = "E3C220ff";
    selection = "3B3724ff";
    selection-text = "F6EEC9ff";
    selection-match = "EFDD84ff";
  };
}
```

### gtk.nix

```nix
{
  gtk = {
    theme = {
      name = "Adwaita-dark";
      package = "gnome-themes-extra";
    };
    iconTheme = {
      name = "Adwaita";
      package = "adwaita-icon-theme";
    };
  };

  qt = {
    platformTheme = "gtk";
    style = "adwaita-dark";
  };

  cursor = {
    package = ["catppuccin-cursors" "mochaYellow"];
    name = "catppuccin-mocha-yellow-cursors";
    size = 26;
  };
}
```

### gnome.nix

Consumed by `modules/home/gnome-theme.nix` (the `gnome` home profile, used on jtop):

- `adwaita`: libadwaita CSS variables (without the `--`), written to `~/.config/gtk-4.0/gtk.css`
- `gtk3`: GTK3 `@define-color` named colours on top of Adwaita-dark, written to `~/.config/gtk-3.0/gtk.css`
- `shell`: `base` (`dark`/`light` upstream stylesheet), `accent`/`accentFg` (replace `-st-accent-color`/`-st-accent-fg-color`), and `greyRamp` (`[[level "#rrggbb"] ...]`). The GNOME Shell theme is generated at build time by extracting the installed gnome-shell's own stylesheet and mapping every neutral grey through the ramp (`modules/home/gnome-shell-recolor.py`), so it always matches the GNOME version. It is loaded through the User Themes extension.

## Available Themes

- `gars-yellow-dark` - Warm yellow accents on dark brown-black background
- `gars-yellow-light` - Warm yellow accents on light cream background

## Usage

Set `my.guiTheme` in your configuration to select a theme:

```nix
my.guiTheme = "gars-yellow-dark";
```

The theme data is exposed via `config.my.guiThemeData.<app>` for use in module configurations.
