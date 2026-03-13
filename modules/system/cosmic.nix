#
# ~/nixos-config/modules/system/cosmic.nix
#
# System76 COSMIC desktop environment.
# Requires nixos-cosmic flake input + cosmicCache module in flake.nix.
# COSMIC manages its own compositor (cosmic-comp) and greeter automatically.
#

{ config, pkgs, ... }:

{
  # ── COSMIC DE ─────────────────────────────────────────────────────────
  services.desktopManager.cosmic.enable  = true;
  services.displayManager.cosmic-greeter.enable = true;

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

  # ── Fonts ─────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    roboto-mono
    noto-fonts
    openmoji-color
  ];

  # ── XDG portals — COSMIC provides its own, just ensure it's on ────────
  xdg.portal.enable = true;

  # ── Session variables ─────────────────────────────────────────────────
  environment.sessionVariables = {
    # Enables clipboard manager support (e.g. for wl-clipboard tools)
    COSMIC_DATA_CONTROL_ENABLED = "1";
  };
}
