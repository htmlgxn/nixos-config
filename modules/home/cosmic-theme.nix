# COSMIC theming from the shared GUI theme (my.guiTheme): GTK colours and
# cursor (gtk-theme.nix), the COSMIC dark theme builder and the wallpaper,
# written through cosmic-manager.
{
  config,
  lib,
  ...
}: let
  themeName = config.my.guiTheme;
  theme =
    config.my.guiThemeData.cosmic
    or (throw "GUI theme '${themeName}' has no COSMIC variant (themes/gui/${themeName}/cosmic.nix)");

  # "#RRGGBB" -> COSMIC RON colour ({red, green, blue} in 0..1, optional-wrapped).
  channel = hex: i: (lib.fromHexString (builtins.substring i 2 hex)) / 255.0;
  srgb = color: let
    hex = lib.removePrefix "#" color;
  in {
    __type = "optional";
    value = {
      red = channel hex 0;
      green = channel hex 2;
      blue = channel hex 4;
    };
  };
  srgba = color:
    lib.recursiveUpdate (srgb color) {value.alpha = 1.0;};
in {
  imports = [./gtk-theme.nix];

  wayland.desktopManager.cosmic = {
    appearance.theme = {
      inherit (theme) mode;
      ${theme.mode} = {
        accent = srgb theme.accent;
        bg_color = srgba theme.bg;
        primary_container_bg = srgba theme.primaryContainer;
        secondary_container_bg = srgba theme.secondaryContainer;
        neutral_tint = srgb theme.neutralTint;
        text_tint = srgb theme.textTint;
      };
    };

    wallpapers = [
      {
        output = "all";
        source = {
          __type = "enum";
          variant = "Path";
          value = ["${config.my.wallpaper}"];
        };
        filter_by_theme = false;
        filter_method = {
          __type = "enum";
          variant = "Lanczos";
        };
        scaling_mode = {
          __type = "enum";
          variant = "Zoom";
        };
        sampling_method = {
          __type = "enum";
          variant = "Alphanumeric";
        };
        rotation_frequency = 300;
      }
    ];
  };
}
