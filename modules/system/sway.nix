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
      # JetBrains Mono Nerd Font as fallback for symbols/glyphs only
      # Primary UI font is Roboto Mono (from gui-base.nix)
      nerd-fonts.jetbrains-mono
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
