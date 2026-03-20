#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-light/sway.nix
#
# Sway colors theme: gars-yellow-light
#
{
  colors = {
    focused = {
      border = "#c9aa10";
      background = "#f5f0d5";
      text = "#1e1a06";
      indicator = "#f5e070";
      childBorder = "#c9aa10";
    };
    focusedInactive = {
      border = "#6b5a0a";
      background = "#f5f0d5";
      text = "#8a8460";
      indicator = "#6b5a0a";
      childBorder = "#6b5a0a";
    };
    unfocused = {
      border = "#aea87c";
      background = "#e2dcb0";
      text = "#cdc79a";
      indicator = "#aea87c";
      childBorder = "#aea87c";
    };
    urgent = {
      border = "#b85010";
      background = "#aea87c";
      text = "#1e1a06";
      indicator = "#b85010";
      childBorder = "#b85010";
    };
    background = "#fdfae8";
  };

  seat = {
    xcursor-theme = "catppuccin-mocha-yellow-cursors 26";
  };
}
