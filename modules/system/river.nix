#
# ~/nixos-config/modules/system/river.nix
#
# River — minimalist dynamic tiling Wayland compositor (wlroots-based).
# Layout managers are separate processes; rivertile is the built-in one.
# Everything is configured via riverctl commands, typically in ~/.config/river/init.
#

{ config, pkgs, ... }:

{
  programs.river = {
    enable          = true;
    xwayland.enable = true;
  };

  security.polkit.enable  = true;
  security.rtkit.enable   = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.pipewire = {
    enable       = true;
    alsa.enable  = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd river";
      user    = "greeter";
    };
  };

  fonts.packages = with pkgs; [
    roboto-mono
    noto-fonts
    openmoji-color
  ];

  xdg.portal = {
    enable       = true;
    wlr.enable   = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    slurp
  ];
}
