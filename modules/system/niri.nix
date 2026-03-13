#
# ~/nixos-config/modules/system/niri.nix
#
# Niri — scrollable-tiling Wayland compositor (Smithay-based).
# Notable: no built-in XWayland. Use xwayland-satellite as a workaround.
# Config lives at ~/.config/niri/config.kdl (KDL format).
#

{ config, pkgs, ... }:

{
  # ── Niri ──────────────────────────────────────────────────────────────
  programs.niri.enable = true;
  # programs.niri.package = pkgs.niri;  # nixpkgs stable build
  # For bleeding-edge, use the niri-flake input and set package there.

  # ── Security ──────────────────────────────────────────────────────────
  security.polkit.enable  = true;
  security.rtkit.enable   = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # ── Audio ─────────────────────────────────────────────────────────────
  services.pipewire = {
    enable       = true;
    alsa.enable  = true;
    pulse.enable = true;
  };

  # ── Greeter ───────────────────────────────────────────────────────────
  # niri-session sets up the proper systemd user session; use it, not bare niri.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
      user    = "greeter";
    };
  };

  # ── Fonts ─────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    roboto-mono
    noto-fonts
    openmoji-color
  ];

  # ── XDG portals ───────────────────────────────────────────────────────
  # xdg-desktop-portal-gnome handles screen sharing for Niri.
  # It tries to use Nautilus for file picking — install nautilus or
  # switch to xdg-desktop-portal-gtk if you don't want the GNOME dep.
  xdg.portal = {
    enable       = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # ── Packages ──────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    wayland
    xwayland-satellite  # XWayland for Niri (Niri integrates it automatically)
    waybar
    fuzzel
    wl-clipboard
    grim
    slurp
    mako
    swaybg
    swaylock
    swayidle
  ];
}
