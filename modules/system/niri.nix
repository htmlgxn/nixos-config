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
