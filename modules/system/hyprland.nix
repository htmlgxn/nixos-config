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
      # JetBrains Mono Nerd Font as fallback for symbols/glyphs only
      # Primary UI font is Roboto Mono (from gui-base.nix)
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
}
