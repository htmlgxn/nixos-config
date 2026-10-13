# janine's COSMIC dock (jtop-cosmic output): same apps as her GNOME dock.
# COSMIC pins apps by desktop-entry id (the .desktop name without suffix).
_: {
  # No idle suspend (see configuration.nix); lid close still sleeps. The screen
  # turns off after 10 minutes, matching GNOME's idle-delay.
  wayland.desktopManager.cosmic.idle = {
    screen_off_time = {
      __type = "optional";
      value = 600000;
    };
    suspend_on_ac_time = {
      __type = "optional";
      value = null;
    };
    suspend_on_battery_time = {
      __type = "optional";
      value = null;
    };
  };

  wayland.desktopManager.cosmic.applets.app-list.settings.favorites = [
    "brave-browser"
    "signal"
    "spotify"
    "startcenter"
    "com.system76.CosmicFiles"
  ];
}
