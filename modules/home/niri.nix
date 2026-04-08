# Niri Home Manager configuration.
{
  config,
  pkgs,
  lib,
  ...
}: let
  waybar = import ./waybar-settings.nix {inherit pkgs config;};
  theme = config.my.guiThemeData.niri;
  mod = "Mod";
  term = config.my.terminal;
  menu = "fuzzel";
  workspaceKeys = (map toString (builtins.genList (x: x + 1) 9)) ++ ["0"];
  workspaceIndex = key:
    if key == "0"
    then "10"
    else key;
  mkWorkspaceBinds = prefix: action:
    lib.concatMapStrings (key: ''
      ${prefix}${key} {
        ${action (workspaceIndex key)}
      }
    '')
    workspaceKeys;
  niriConfig = ''
    // Generated from modules/home/niri.nix
    // Intended to stay as close to the Sway workflow as Niri allows.

    input {
        keyboard {
            xkb {
                layout "us,graphite"
                options "caps:escape,grp:alt_shift_toggle"
            }
        }
    }

    prefer-no-csd

    layout {
        gaps ${toString theme.layout.gaps}

        focus-ring {
            width ${toString theme.layout.focus-ring.width}
            active-color "${theme.layout.focus-ring.active-color}"
            inactive-color "${theme.layout.focus-ring.inactive-color}"
        }

        background-color "${theme.layout.background-color}"
    }

    window-rule {
        match app-id=r#"^pavucontrol$"#
        open-floating true
    }

    window-rule {
        match title="Volume Control"
        open-floating true
    }

    binds {
        ${mod}+Return { spawn "${term}"; }
        ${mod}+Q { close-window; }
        ${mod}+Shift+Q { close-window; }

        ${mod}+Space { spawn "${menu}"; }

        ${mod}+F2 { spawn "brave"; }
        ${mod}+F3 { spawn "thunar"; }
        ${mod}+Shift+X { spawn "swaylock" "-f" "-c" "000000"; }

        ${mod}+H { focus-column-left; }
        ${mod}+J { focus-window-down; }
        ${mod}+K { focus-window-up; }
        ${mod}+L { focus-column-right; }

        ${mod}+Left { focus-column-left; }
        ${mod}+Down { focus-window-down; }
        ${mod}+Up { focus-window-up; }
        ${mod}+Right { focus-column-right; }

        ${mod}+Shift+H { move-column-left; }
        ${mod}+Shift+J { move-window-down; }
        ${mod}+Shift+K { move-window-up; }
        ${mod}+Shift+L { move-column-right; }

        ${mod}+Shift+Left { move-column-left; }
        ${mod}+Shift+Down { move-window-down; }
        ${mod}+Shift+Up { move-window-up; }
        ${mod}+Shift+Right { move-column-right; }

        ${mod}+BracketRight { focus-workspace-down; }
        ${mod}+BracketLeft { focus-workspace-up; }
        ${mod}+Ctrl+Right { focus-workspace-down; }
        ${mod}+Ctrl+Left { focus-workspace-up; }

        ${mod}+S { switch-preset-column-width; }
        ${mod}+W { toggle-column-tabbed-display; }
        ${mod}+E { focus-column-first; }

        ${mod}+F { fullscreen-window; }
        ${mod}+Shift+Space { toggle-window-floating; }
        ${mod}+Shift+F { switch-focus-between-floating-and-tiling; }

        Print {
            spawn "${pkgs.bash}/bin/sh" "-lc" "grim $HOME/pictures/screenshots/$(date +%Y%m%d_%H%M%S).png";
        }

        ${mod}+Print { screenshot-window; }

        ${mod}+Ctrl+Print {
            spawn "${pkgs.bash}/bin/sh" "-lc" "grim -g \"$(slurp)\" $HOME/pictures/screenshots/$(date +%Y%m%d_%H%M%S).png";
        }

        ${mod}+Shift+A { screenshot-window write-to-disk=false; }

        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
        XF86AudioMicMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

        ${mod}+F11 { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
        ${mod}+F12 { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }

        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }
        ${mod}+F9 { spawn "brightnessctl" "set" "5%-"; }
        ${mod}+F10 { spawn "brightnessctl" "set" "5%+"; }

        ${mod}+Shift+E { quit; }

        ${mkWorkspaceBinds "${mod}+" (workspace: ''focus-workspace ${workspace};'')}
        ${mkWorkspaceBinds "${mod}+Ctrl+" (workspace: ''move-column-to-workspace ${workspace} focus=false;'')}
        ${mkWorkspaceBinds "${mod}+Shift+" (workspace: ''move-column-to-workspace ${workspace};'')}
    }

    xwayland-satellite {
        path "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
    }

    spawn-at-startup "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "--all"
    spawn-at-startup "gsettings" "set" "org.gnome.desktop.interface" "gtk-theme" "Adwaita-dark"
    spawn-at-startup "gsettings" "set" "org.gnome.desktop.interface" "color-scheme" "prefer-dark"
    spawn-at-startup "swaybg" "-i" "${config.my.wallpaper}" "-m" "fill"
    spawn-at-startup "wlsunset" "-t" "2500" "-T" "3000"
    spawn-at-startup "${pkgs.waybar}/bin/waybar"
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "grass"
    spawn-at-startup "${pkgs.bash}/bin/sh" "-lc" "swayidle -w -c ~/.config/swayidle/config timeout 600 'swaylock -f -c 000000' timeout 900 'niri msg action power-off-monitors' resume 'niri msg action power-on-monitors' before-sleep 'swaylock -f -c 000000'"
  '';
in {
  imports = [
    ./gui-base-apps.nix
  ];

  home.packages = with pkgs; [
    # Niri-specific
    grim # screenshot capture (used by niri's screenshot action)
  ];

  programs.waybar.settings = {
    mainBar =
      waybar.common
      // {
        "modules-left" = ["niri/workspaces" "niri/window"];

        "niri/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
          format = "{name}";
        };

        "niri/window" = {
          "max-length" = 60;
          ellipsis = "...";
        };
      };
  };

  xdg.configFile."niri/config.kdl".text = niriConfig;
}
