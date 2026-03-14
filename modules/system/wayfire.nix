#
# ~/nixos-config/modules/system/wayfire.nix
#
# Wayfire — plugin-based Wayland compositor (wlroots-based).
# Compiz-style effects, gestures, wobbly windows.
# Config lives at ~/.config/wayfire.ini
#

{ config, pkgs, ... }:

{
  programs.wayfire = {
    enable  = true;
    plugins = with pkgs.wayfirePlugins; [
      wcm
      wf-shell
    ];
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
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd wayfire";
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
