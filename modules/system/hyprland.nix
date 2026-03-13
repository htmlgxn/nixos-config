#
# ~/nixos-config/modules/system/hyprland.nix
#
# Hyprland — dynamic tiling Wayland compositor.
# Uses its own aquamarine GPU backend (forked from wlroots).
#

{ config, pkgs, ... }:

{
  # ── Hyprland ──────────────────────────────────────────────────────────
  programs.hyprland = {
    enable          = true;
    xwayland.enable = true;
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
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd Hyprland";
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
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # ── Packages ──────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    waybar
    fuzzel        # launcher (same as sway setup)
    wl-clipboard
    grim          # screenshot
    slurp         # region select
    mako          # notifications
    swww          # animated wallpaper daemon
    hyprlock      # lockscreen
    hypridle      # idle daemon
  ];
}
