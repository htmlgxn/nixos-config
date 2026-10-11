# GNOME Shell layout for non-technical users: an always-visible dock,
# normal minimize/maximize/close buttons, and no surprise overview on
# hot corners or at login. Pinned apps (favorite-apps) are set per host.
{
  config,
  lib,
  ...
}: let
  inherit (lib.hm.gvariant) mkUint32;
in {
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dock-fixed = true;
      extend-height = false;
      dash-max-icon-size = 40;
      # Trim the dock's padding around the icons.
      custom-theme-shrink = true;
      show-trash = false;
      show-mounts = false;
      disable-overview-on-startup = true;
      click-action = "focus-minimize-or-previews";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    # Night Light, always on (from == to means the full 24h in
    # gnome-settings-daemon) at the same daytime temperature as wlsunset on the
    # sway hosts. GNOME applies a single temperature, so there is no separate
    # warmer night step.
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = mkUint32 config.my.nightLight.dayTemperature;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 0.0;
      night-light-schedule-to = 0.0;
    };

    # Blank the screen after 10 minutes idle.
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 600;
    };
  };
}
