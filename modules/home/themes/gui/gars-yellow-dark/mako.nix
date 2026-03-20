#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-dark/mako.nix
#
# Mako theme: gars-yellow-dark
#
{
  default = {
    background-color = "#262418";
    text-color = "#F6EEC9";
    border-color = "#826F11";
    progress-color = "over #E3C220";
  };

  urgency = {
    low = {
      background-color = "#1E1904";
      text-color = "#A29C7F";
      border-color = "#413C1E";
      default-timeout = 3000;
    };
    normal = {
      background-color = "#262418";
      text-color = "#F6EEC9";
      border-color = "#826F11";
      default-timeout = 5000;
    };
    high = {
      background-color = "#322F1F";
      border-color = "#E08850";
      text-color = "#E08850";
      default-timeout = 0;
    };
    hidden = {
      background-color = "#1E1904";
      text-color = "#5B5742";
      border-color = "#413C1E";
    };
  };
}
