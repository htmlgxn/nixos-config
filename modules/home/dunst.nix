#
# ~/nixos-config/modules/home/dunst.nix
#
# Dunst notification daemon configuration managed by Home Manager.
# X11 equivalent of mako.nix. Colors pulled from config.my.guiThemeData.mako.
#
{config, ...}: let
  theme = config.my.guiThemeData.mako;
in {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 320;
        height = 150;
        corner_radius = 0;
        font = "Roboto Mono 11";
        frame_width = 1;
        frame_color = theme.default.border-color;
        separator_color = "frame";
        padding = 10;
        horizontal_padding = 14;
        notification_limit = 5;
        sort = "yes";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        history_length = 20;
        show_indicators = "yes";
        icon_position = "left";
        max_icon_size = 32;
        sticky_history = "yes";
        word_wrap = true;
        ellipsize = "middle";
        show_age_threshold = 60;
      };

      urgency_low = {
        background = theme.urgency.low.background-color;
        foreground = theme.urgency.low.text-color;
        frame_color = theme.urgency.low.border-color;
        timeout = theme.urgency.low.default-timeout / 1000;
      };

      urgency_normal = {
        background = theme.urgency.normal.background-color;
        foreground = theme.urgency.normal.text-color;
        frame_color = theme.urgency.normal.border-color;
        timeout = theme.urgency.normal.default-timeout / 1000;
      };

      urgency_critical = {
        background = theme.urgency.high.background-color;
        foreground = theme.urgency.high.text-color;
        frame_color = theme.urgency.high.border-color;
        timeout = 0;
      };
    };
  };
}
