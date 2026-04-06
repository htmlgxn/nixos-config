# i3 window manager configuration for aarch64 Jetson (L4T/Ubuntu + standalone HM).
# Mirrors sway.nix keybindings and colors as closely as possible using i3's HM module.
{
  config,
  lib,
  ...
}: let
  theme = config.my.guiThemeData.sway;
  mod = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  term = config.my.terminal;

  workspaceKeys = builtins.genList (x: x + 1) 9;
  mkWorkspaceBindingsWithZero = prefix: fn: let
    keys = (map toString workspaceKeys) ++ ["0"];
    toWorkspace = k:
      if k == "0"
      then "10"
      else k;
  in
    lib.listToAttrs (map (k: {
        name = "${prefix}${k}";
        value = fn (toWorkspace k);
      })
      keys);
in {
  imports = [./x11-base.nix];

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      terminal = term;
      menu = "rofi -show drun";

      window = {
        titlebar = false;
        border = 2;
      };

      floating = {
        titlebar = false;
        border = 2;
        modifier = mod;
      };

      workspaceAutoBackAndForth = true;

      gaps = {
        inner = 2;
        outer = 2;
        smartGaps = true;
        smartBorders = "on";
      };

      bars = [];

      inherit (theme) colors;

      keybindings =
        {
          "${mod}+Return" = "exec ${term}";
          "${mod}+q" = "kill";
          "${mod}+Space" = "exec rofi -show drun";

          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+bracketright" = "workspace next";
          "${mod}+bracketleft" = "workspace prev";

          "${mod}+f" = "fullscreen toggle";
          "${mod}+Shift+space" = "floating toggle";
          "${mod}+r" = "mode resize";
          "${mod}+Shift+x" = "exec i3lock -c 000000";

          "Print" = "exec scrot ~/pictures/screenshots/$(date +%Y%m%d_%H%M%S).png";

          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        }
        // mkWorkspaceBindingsWithZero "${mod}+" (n: "workspace number ${n}")
        // mkWorkspaceBindingsWithZero "${mod}+Shift+" (n: "move container to workspace number ${n}; workspace number ${n}");

      modes = {
        resize = {
          "${left}" = "resize shrink width 10px";
          "${down}" = "resize grow height 10px";
          "${up}" = "resize shrink height 10px";
          "${right}" = "resize grow width 10px";

          "Left" = "resize shrink width 20px";
          "Down" = "resize grow height 20px";
          "Up" = "resize shrink height 20px";
          "Right" = "resize grow width 20px";

          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };

      startup = [
        {
          command = "feh --bg-fill ${config.my.wallpaper}";
          always = true;
        }
        {command = "picom";}
        {command = "dunst";}
        {command = "nm-applet";}
        {command = "xss-lock -- i3lock -c 000000";}
      ];
    };

    extraConfig = ''
      font pango:Roboto Mono 10

      exec_always gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
      exec_always gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    '';
  };
}
