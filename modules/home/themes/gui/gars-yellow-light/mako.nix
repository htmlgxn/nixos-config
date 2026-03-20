#
# ~/nixos-config/modules/home/themes/gui/gars-yellow-light/mako.nix
#
# Mako theme: gars-yellow-light
#
{
  default = {
    background-color = "#ece7c0";
    text-color = "#1e1a06";
    border-color = "#6b5a0a";
    progress-color = "over #c9aa10";
  };

  urgency = {
    low = {
      background-color = "#f5f0d5";
      text-color = "#8a8460";
      border-color = "#aea87c";
      default-timeout = 3000;
    };
    normal = {
      background-color = "#ece7c0";
      text-color = "#1e1a06";
      border-color = "#6b5a0a";
      default-timeout = 5000;
    };
    high = {
      background-color = "#f5f0d5";
      border-color = "#b85010";
      text-color = "#b85010";
      default-timeout = 0;
    };
    hidden = {
      background-color = "#f5f0d5";
      text-color = "#cdc79a";
      border-color = "#aea87c";
    };
  };
}
