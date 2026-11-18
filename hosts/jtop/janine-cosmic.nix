# janine's COSMIC session on jtop: idle settings and dock pins.
# COSMIC pins apps by desktop-entry id (the .desktop name without suffix).
{config, ...}: {
  # Night light (hosts/jtop/nightlight.nix) on all day at the same daytime
  # temperature as wlsunset on the sway hosts: no schedule, forced on. Written
  # with cosmic-ctl on each switch, so changes made in its settings window
  # last until the next rebuild.
  wayland.desktopManager.cosmic.configFile."io.github.cosmic_nightlight" = {
    version = 1;
    entries = {
      schedule = "manual";
      override = "on";
      temperature = config.my.nightLight.dayTemperature;
      brightness = 1.0;
    };
  };

  # No idle suspend (see configuration.nix); lid close still sleeps. The screen
  # turns off after 10 minutes.
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
    "ai.storyteller.wordcraft"
    "com.system76.CosmicFiles"
  ];
}
