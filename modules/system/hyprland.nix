# Hyprland system profile additions.
{
  config,
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

  programs.dconf.enable = true;

  services.greetd.settings.default_session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --cmd Hyprland";
    user = "greeter";
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts.emoji = ["OpenMoji Color"];
    };
  };

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
  ];

  environment.systemPackages = with pkgs; [
    xwayland
  ];

  environment.variables = {
    XCURSOR_THEME = "Catppuccin-Mocha-Yellow-Cursors";
    XCURSOR_SIZE = "26";
  };
}
