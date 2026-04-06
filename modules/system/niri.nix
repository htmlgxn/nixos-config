# Niri system profile additions.
{pkgs, ...}: {
  imports = [
    ./gui-base.nix
  ];

  programs.niri.enable = true;

  services.greetd.settings.default_session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
    user = "greeter";
  };

  fonts.packages = with pkgs; [
    noto-fonts
  ];

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gnome
    pkgs.xdg-desktop-portal-wlr
  ];

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    slurp
    swaybg
    swaylock
  ];
}
