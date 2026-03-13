#
# ~/nixos-config/modules/system/river.nix
#
# River — minimalist dynamic tiling Wayland compositor (wlroots-based).
# Layout managers are separate processes; rivertile is the built-in one.
# Everything is configured via riverctl commands, typically in ~/.config/river/init.
#

{ config, pkgs, ... }:

{
  # ── River ─────────────────────────────────────────────────────────────
  programs.river = {
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
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd river";
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
    wlr.enable   = true;     # wlroots-based portal (screen share etc.)
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ── Packages ──────────────────────────────────────────────────────────
  # rivertile and riverctl are bundled in the river package itself.
  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    waybar
    fuzzel
    wl-clipboard
    grim
    slurp
    mako
    swaybg
    swaylock
    swayidle
    # Optional: community layout managers
    # river-bsp-layout   # binary space partitioning layout
    # stacktile          # stacking/monocle layout
  ];
}
