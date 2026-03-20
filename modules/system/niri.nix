# Niri system profile additions.
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gui-base.nix
  ];

  programs.niri.enable = true;

  programs.dconf.enable = true;

  services.greetd.settings.default_session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
    user = "greeter";
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      # JetBrains Mono Nerd Font as fallback for symbols/glyphs only
      # Primary UI font is Roboto Mono (from gui-base.nix)
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts.emoji = ["OpenMoji Color"];
    };
  };

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gnome
    pkgs.xdg-desktop-portal-wlr
  ];

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    slurp
    swaybg
    swaylock
    catppuccin-cursors.mochaYellow
  ];
}
