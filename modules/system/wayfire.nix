#
# ~/nixos-config/modules/system/wayfire.nix
#
# Wayfire — plugin-based Wayland compositor (wlroots-based).
# Compiz-style effects, gestures, wobbly windows.
# Config lives at ~/.config/wayfire.ini
#

{ config, pkgs, ... }:

{
  # ── Wayfire ───────────────────────────────────────────────────────────
  programs.wayfire = {
    enable  = true;
    plugins = with pkgs.wayfirePlugins; [
      wcm        # Wayfire Config Manager — GUI settings editor
      wf-shell   # panel, background, taskbar for Wayfire
    ];
  };

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
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd wayfire";
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
  xdg.portal = {
    enable       = true;
    wlr.enable   = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ── Packages ──────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    wl-clipboard
    grim
    slurp
    mako
    swaybg
    swaylock
    swayidle
    # wf-shell (wf-panel, wf-background etc.) comes via plugins above
  ];
}
