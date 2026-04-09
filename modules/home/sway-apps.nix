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
}
