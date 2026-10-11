# GNOME Shell layout for non-technical users: an always-visible dock,
# normal minimize/maximize/close buttons, and no surprise overview on
# hot corners or at login. Pinned apps (favorite-apps) are set per host.
{lib, ...}: let
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
      dash-max-icon-size = 56;
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

    # Blank the screen after 10 minutes idle.
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 600;
    };
  };
}
