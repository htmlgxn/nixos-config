#
# ~/nixos-config/modules/system/sway.nix
#

{ config, pkgs, ... }:

{
  # Enable sway at system level
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Needed for sway to function properly
  security.polkit.enable = true;
  security.rtkit.enable = true;

  # Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Login manager — greetd is lightweight and terminal-friendly
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd sway";
        user = "greeter";
      };
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    roboto-mono
    noto-fonts
    openmoji-color
  ];

  # XDG portals — needed for screen sharing, file pickers etc on Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    swaybg
    swaylock
    swayidle
    waybar
    wofi
    wl-clipboard
    grim
    slurp
    mako
  ];
}
