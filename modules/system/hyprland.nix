# Hyprland system profile additions.
{
  pkgs,
  ...
}: {
  imports = [
    ./gui-base.nix
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd.settings.default_session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --cmd Hyprland";
    user = "greeter";
  };

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
  ];

  environment.systemPackages = with pkgs; [
    xwayland
  ];
}
