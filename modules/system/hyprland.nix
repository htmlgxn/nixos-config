#
# ~/nixos-config/modules/system/hyprland.nix
#
# Hyprland — dynamic tiling Wayland compositor.
# Uses its own aquamarine GPU backend (forked from wlroots).
#

{ config, pkgs, ... }:

{
  programs.hyprland = {
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
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd Hyprland";
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
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    slurp
    hyprlock
    hypridle
    swww
  ];
}
