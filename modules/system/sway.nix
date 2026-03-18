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

  programs.dconf.enable = true;

  services.greetd.settings = {
    default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd sway";
      user = "greeter";
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono # TODO: change to match gui-base.nix
    ];
    fontconfig = {
      defaultFonts.emoji = ["OpenMoji Color"];
    };
  };

  xdg.portal.wlr.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland
    wofi
  ];
}
