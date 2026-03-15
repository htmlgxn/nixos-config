#
# ~/nixos-config/modules/system/niri.nix
#
# Niri — scrollable-tiling Wayland compositor (Smithay-based).
# Notable: no built-in XWayland. Use xwayland-satellite as a workaround.
# Config lives at ~/.config/niri/config.kdl (KDL format).
#
{
  config,
  pkgs,
  ...
}: {
  programs.niri.enable = true;

  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
      user = "greeter";
    };
  };

  fonts.packages = with pkgs; [
    roboto-mono
    noto-fonts
    openmoji-color
  ];

  environment.variables = {
    GTK_THEME = "Adwaita-dark";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  environment.systemPackages = with pkgs; [
    wayland
    xwayland-satellite
    slurp
    swaybg
    swaylock
  ];
}
