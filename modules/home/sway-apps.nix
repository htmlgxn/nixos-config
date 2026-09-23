# Packages for sway desktop environments.
# Separated from sway.nix so hosts with incompatible GPU drivers (e.g. Jetson)
# can use the sway-config profile for declarative configs without nix packages.
{
  config,
  pkgs,
  lib,
  ...
}: let
  clipdoc = import ./clipdoc.nix {inherit pkgs;};
in {
  imports = [
    ./gui-base-apps.nix
  ];

  home.packages = with pkgs;
    [
      # ── Wayland / Sway ───────────────────────────────────────────────
      sway-contrib.grimshot
      clipdoc.clipdoc
      swaybg
      swaylock
      wl-clipboard
      grim

      # ── Desktop Utilities (Linux) ────────────────────────────────────
      thunar
      pavucontrol
      brightnessctl

      # ── GTK Theming ──────────────────────────────────────────────────
      gsettings-desktop-schemas
      glib
    ]
    ++ lib.optionals (config.my.terminal == "foot") [
      foot
    ];

  # ── Session services (systemd user units bound to sway-session.target) ──
  # sway.nix falls back to `exec` lines for hosts without these (sway-config).
  services = let
    swaylock = "${lib.getExe pkgs.swaylock} -f -c 000000";
    swaymsg = lib.getExe' pkgs.sway "swaymsg";
  in {
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 600;
          command = swaylock;
        }
        {
          timeout = 900;
          command = "${swaymsg} 'output * power off'";
          resumeCommand = "${swaymsg} 'output * power on'";
        }
      ];
      events.before-sleep = swaylock;
    };

    # Halifax (matches time.timeZone); wlsunset needs a location or fixed times.
    wlsunset = {
      enable = true;
      latitude = 44.6;
      longitude = -63.6;
      temperature = {
        day = 3000;
        night = 2500;
      };
    };

    polkit-gnome.enable = true;
    network-manager-applet.enable = true;
  };

  # nm-applet --indicator (StatusNotifierItem) for the waybar tray.
  xsession.preferStatusNotifierItems = true;
}
