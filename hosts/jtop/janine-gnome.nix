# janine's GNOME dock (jtop output).
_: {
  # No idle suspend (see configuration.nix); lid close still sleeps.
  dconf.settings."org/gnome/settings-daemon/plugins/power" = {
    sleep-inactive-ac-type = "nothing";
    sleep-inactive-battery-type = "nothing";
  };

  dconf.settings."org/gnome/shell".favorite-apps = [
    "brave-browser.desktop"
    "signal.desktop"
    "spotify.desktop"
    "startcenter.desktop"
    "org.gnome.Nautilus.desktop"
  ];
}
