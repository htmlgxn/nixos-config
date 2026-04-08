# Sway Home Manager configuration.
{
  config,
  pkgs,
  lib,
  ...
}: let
  waybar = import ./waybar-settings.nix {inherit pkgs config;};
  clipdoc = import ./clipdoc.nix {inherit pkgs;};
  guiTheme = config.my.guiThemeData;
  theme = guiTheme.sway;
  resolvePkg = path: builtins.foldl' (pkg: attr: pkg.${attr}) pkgs path;
  mod = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  term = config.my.terminal;
  menu = "fuzzel";

  # Generate workspace keybindings for numbers 1-9 (0 is workspace 10)
  workspaceKeys = builtins.genList (x: x + 1) 9; # [1 2 3 4 5 6 7 8 9]
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
  imports = [
    ./gui-base-apps.nix
    ./gui-theme.nix
    ./terminal-theme.nix
    ./alacritty.nix
    ./kitty.nix
    ./fuzzel.nix
    ./mako.nix
  ];

  programs.waybar = {
    enable = true;
    inherit (waybar) style;
    systemd = {
      enable = true;
      targets = ["sway-session.target"];
    };
  };

  home.packages = with pkgs;
    [
      # ── Wayland / Sway ───────────────────────────────────────────────
      sway-contrib.grimshot
      clipdoc.clipdoc
      swaybg
      swaylock
      swayidle
      wlsunset
      wl-clipboard
      grim

      # ── Desktop Utilities (Linux) ────────────────────────────────────
      thunar
      pavucontrol
      brightnessctl
      polkit_gnome
      networkmanagerapplet

      # ── GTK Theming ──────────────────────────────────────────────────
      gsettings-desktop-schemas
      glib
    ]
    ++ lib.optionals (config.my.terminal == "foot") [
      foot
    ];

  # ── GTK / QT Theming ──────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      inherit (guiTheme.gtk.gtk.theme) name;
      package = resolvePkg guiTheme.gtk.gtk.theme.package;
    };
    iconTheme = {
      inherit (guiTheme.gtk.gtk.iconTheme) name;
      package = resolvePkg guiTheme.gtk.gtk.iconTheme.package;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = guiTheme.gtk.qt.platformTheme;
    style.name = guiTheme.gtk.qt.style;
  };

  # ── Cursor Theme ──────────────────────────────────────────────────
  home.pointerCursor = {
    gtk.enable = true;
    package = resolvePkg guiTheme.gtk.cursor.package;
    inherit (guiTheme.gtk.cursor) name;
    inherit (guiTheme.gtk.cursor) size;
  };

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    extraSessionCommands = ''
      export XDG_DATA_DIRS="${config.home.homeDirectory}/.local/share/flatpak/exports/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
    '';
    config = {
      modifier = mod;
      inherit left;
      inherit down;
      inherit up;
      inherit right;
      terminal = term;
      inherit menu;

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
          xkb_layout =
            if config.my.dualKeyboardLayout
            then "us,graphite"
            else "us";
          # xkb_options = "caps:escape"; # Defined by Keychron settings now - uncomment if changes
          xkb_numlock = "true";
        };
      };

      seat = {
        seat0 = {
          xcursor_theme = theme.seat."xcursor-theme";
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

      inherit (theme) colors;

      keybindings =
        {
          "${mod}+Return" = "exec ${term}";
          "${mod}+q" = "kill";
          "${mod}+Shift+q" = "exec swaymsg \"[workspace=__focused__] kill\"";

          "${mod}+Space" = "exec ${menu}";
          "${mod}+period" = "exec emoji-picker";
          "${mod}+Shift+period" = "exec EMOJI_PICKER_NO_TYPE=1 emoji-picker";
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

          # Workspace bindings (1-10)
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
          "${mod}+Shift+a" = "exec grimshot copy window";
          "${mod}+Shift+x" = "exec swaylock -f -c 000000";
          "Print" = "exec grim ~/pictures/screenshots/$(date +%Y%m%d_%H%M%S).png";
          "${mod}+Print" = "exec grimshot save window ~/pictures/screenshots/$(date +%Y%m%d_%H%M%S).png";
          "${mod}+Ctrl+Print" = "exec grimshot save area ~/pictures/screenshots/$(date +%Y%m%d_%H%M%S).png";
        }
        // mkWorkspaceBindingsWithZero "${mod}+" (n: "workspace number ${n}")
        // mkWorkspaceBindingsWithZero "${mod}+Ctrl+" (n: "move container to workspace number ${n}")
        // mkWorkspaceBindingsWithZero "${mod}+Shift+" (n: "move container to workspace number ${n}; workspace ${n}")
        // lib.optionalAttrs config.my.dualKeyboardLayout {
          "Mod1+Shift_L" = "input type:keyboard xkb_switch_layout next";
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
      font pango:Roboto Mono 10
      titlebar_padding 4 3

      # Start on workspace 1
      workspace 1

      exec_always gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
      exec_always gsettings set org.gnome.desktop.interface color-scheme prefer-dark

      exec_always swaybg -i ${config.my.wallpaper} -m fill
      exec wlsunset -t 2500 -T 3000

      exec_always ${pkgs.systemd}/bin/systemctl --user restart waybar
      exec eval $(gnome-keyring-daemon --start)
      exec export SSH_AUTH_SOCK
      exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      exec nm-applet --indicator
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
