#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-light/mako.nix
#
# Mako theme: gars-yellow-light
#
{
  default = {
    background-color = "#c4be86";
    text-color = "#1e1a06";
    border-color = "#6b5a0a";
    progress-color = "over #c9aa10";
  };

  urgency = {
    low = {
      background-color = "#d8d2a2";
      text-color = "#8a8460";
      border-color = "#aea87c";
      default-timeout = 3000;
    };
    normal = {
      background-color = "#c4be86";
      text-color = "#1e1a06";
      border-color = "#6b5a0a";
      default-timeout = 5000;
    };
    high = {
      background-color = "#d8d2a2";
      border-color = "#b85010";
      text-color = "#b85010";
      default-timeout = 0;
    };
    hidden = {
      background-color = "#d8d2a2";
      text-color = "#c4bd87";
      border-color = "#aea87c";
    };
  };
}
