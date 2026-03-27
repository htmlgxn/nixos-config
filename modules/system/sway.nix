# Sway system profile additions.
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gui-base.nix
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services.greetd.settings.default_session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --cmd sway";
    user = "greeter";
  };

  xdg.portal.wlr.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland
    wofi
  ];
}
