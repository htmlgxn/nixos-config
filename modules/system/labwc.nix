#
# ~/nixos-config/modules/system/labwc.nix
#
# LabWC — stacking (floating) Wayland compositor modeled after Openbox.
# XML config at ~/.config/labwc/{rc.xml, menu.xml, autostart, environment}.
# No programs.labwc NixOS module yet — installed as a package.
#

{ config, pkgs, ... }:

{
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
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd labwc";
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
    labwc
    wayland
    xwayland
    slurp
  ];
}
