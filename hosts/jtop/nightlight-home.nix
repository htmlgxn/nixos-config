# Night light settings for every COSMIC user on jtop (imported by desktop.nix);
# the app itself is set up in nightlight.nix.
# On all day at the same daytime temperature as wlsunset on the sway hosts:
# no schedule, forced on. Written with cosmic-ctl on each switch, so changes
# made in its settings window last until the next rebuild.
{config, ...}: {
  wayland.desktopManager.cosmic.configFile."io.github.cosmic_nightlight" = {
    version = 1;
    entries = {
      schedule = "manual";
      override = "on";
      temperature = config.my.nightLight.dayTemperature;
      brightness = 1.0;
    };
  };
}
