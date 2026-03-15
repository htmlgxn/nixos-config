#
# ~/nixos-config/modules/home/sway.nix
#
# Sway-specific home configuration.
# Imports gui-base.nix for shared packages, adds sway-specific dotfiles.
#
{
  config,
  pkgs,
  ...
}: let
  waybar = import ./waybar-settings.nix {inherit pkgs;};
  mod = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  term = "alacritty";
  menu = "fuzzel";
in {
  imports = [
    ./gui-base.nix
  ];

  home.packages = with pkgs; [
    # Sway-specific
    sway-contrib.grimshot
  ];

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = {
      modifier = mod;
      left = left;
      down = down;
      up = up;
      right = right;
      terminal = term;
      menu = menu;

      window = {
        titlebar = false;
        border = 2;
      };

      floating = {
        titlebar = false;
        border = 2;
        modifier = "${mod} normal";
      };

      input = {
        "*" = {
          xkb_options = "caps:escape";
          xkb_numlock = "true";
        };
      };

      seat = {
        seat0 = {
          xcursor_theme = "catppuccin-mocha-yellow-cursors 26";
        };
      };

      workspaceAutoBackAndForth = true;

      gaps = {
        inner = 2;
        outer = 2;
        smartGaps = true;
        smartBorders = "on";
      };

      bars = [];

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
          border = "#EF9F76";
          background = "#413C1E";
          text = "#F6EEC9";
          indicator = "#EF9F76";
          childBorder = "#EF9F76";
        };
        background = "#1E1904";
      };

      keybindings = {
        "${mod}+Return" = "exec ${term}";
        "${mod}+q" = "kill";
        "${mod}+Shift+q" = "exec swaymsg \"[workspace=__focused__] kill\"";

        "${mod}+Space" = "exec ${menu}";
        "${mod}+d" = null;

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

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

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Ctrl+1" = "move container to workspace number 1";
        "${mod}+Ctrl+2" = "move container to workspace number 2";
        "${mod}+Ctrl+3" = "move container to workspace number 3";
        "${mod}+Ctrl+4" = "move container to workspace number 4";
        "${mod}+Ctrl+5" = "move container to workspace number 5";
        "${mod}+Ctrl+6" = "move container to workspace number 6";
        "${mod}+Ctrl+7" = "move container to workspace number 7";
        "${mod}+Ctrl+8" = "move container to workspace number 8";
        "${mod}+Ctrl+9" = "move container to workspace number 9";
        "${mod}+Ctrl+0" = "move container to workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1; workspace 1";
        "${mod}+Shift+2" = "move container to workspace number 2; workspace 2";
        "${mod}+Shift+3" = "move container to workspace number 3; workspace 3";
        "${mod}+Shift+4" = "move container to workspace number 4; workspace 4";
        "${mod}+Shift+5" = "move container to workspace number 5; workspace 5";
        "${mod}+Shift+6" = "move container to workspace number 6; workspace 6";
        "${mod}+Shift+7" = "move container to workspace number 7; workspace 7";
        "${mod}+Shift+8" = "move container to workspace number 8; workspace 8";
        "${mod}+Shift+9" = "move container to workspace number 9; workspace 9";
        "${mod}+Shift+0" = "move container to workspace number 10; workspace 10";

        "${mod}+bracketright" = "workspace next";
        "${mod}+bracketleft" = "workspace prev";
        "${mod}+Ctrl+Right" = "workspace next";
        "${mod}+Ctrl+Left" = "workspace prev";

        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+f" = "fullscreen";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+Shift+f" = "focus mode_toggle";
        "${mod}+a" = "focus parent";

        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";

        "${mod}+r" = "mode resize";

        "${mod}+F2" = "exec brave";
        "${mod}+F3" = "exec thunar";
        "${mod}+Shift+a" = "exec flameshot gui";
        "${mod}+Shift+x" = "exec swaylock -f -c 000000";

        "Print" = "exec grim ~/Pictures/screenshots/$(date +%Y%m%d_%H%M%S).png";
      };

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
    };

    extraConfig = ''
      font pango:monospace 11
      titlebar_padding 6 4

      exec_always gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
      exec_always gsettings set org.gnome.desktop.interface color-scheme prefer-dark

      exec_always swaybg -i ~/Pictures/wallpapers/jpg/mtl-16.jpg -m fill
      exec wlsunset -t 2500 -T 3000

      exec_always ${pkgs.systemd}/bin/systemctl --user restart waybar
      exec eval $(gnome-keyring-daemon --start)
      exec export SSH_AUTH_SOCK
      exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      exec nm-applet --indicator
      exec flameshot
      exec grass

      exec swayidle -w \
          -c ~/.config/swayidle/config \
          timeout 600 'swaylock -f -c 000000' \
          timeout 900 'swaymsg "output * power off"' \
          resume 'swaymsg "output * power on"' \
          before-sleep 'swaylock -f -c 000000'

      bindsym --locked XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym --locked XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym --locked XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym --locked XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
      bindsym --locked ${mod}+F11 exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym --locked ${mod}+F12 exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
      bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+
      bindsym --locked ${mod}+F9 exec brightnessctl set 5%-
      bindsym --locked ${mod}+F10 exec brightnessctl set 5%+

      include /etc/sway/config.d/*
    '';
  };

  programs.waybar.settings = {
    mainBar =
      waybar.common
      // {
        "modules-left" = ["sway/workspaces" "sway/window" "sway/mode"];

        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
          format = "{name}";
        };

        "sway/window" = {
          "max-length" = 60;
          ellipsis = "...";
        };

        "sway/mode" = {
          format = "{}";
        };
      };
  };
}
