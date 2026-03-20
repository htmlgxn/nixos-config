#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-dark/sway.nix
#
# Sway colors theme: gars-yellow-dark
#
{
  colors = {
    focused = {
      border = "#E3C220";
      background = "#3B3724";
      text = "#F6EEC9";
      indicator = "#EFDD84";
      childBorder = "#E3C220";
    };
    focusedInactive = {
      border = "#826F11";
      background = "#322F1F";
      text = "#A29C7F";
      indicator = "#826F11";
      childBorder = "#826F11";
    };
    unfocused = {
      border = "#413C1E";
      background = "#262418";
      text = "#5B5742";
      indicator = "#413C1E";
      childBorder = "#413C1E";
    };
    urgent = {
      border = "#D07030";
      background = "#413C1E";
      text = "#F6EEC9";
      indicator = "#D07030";
      childBorder = "#D07030";
    };
    background = "#1E1904";
  };

  seat = {
    xcursor-theme = "catppuccin-mocha-yellow-cursors 26";
  };
}
