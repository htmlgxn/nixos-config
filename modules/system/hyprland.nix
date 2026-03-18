#
# ~/nixos-config/modules/system/hyprland.nix
#
# =============================================================================
# SYSTEM CONFIGURATION: Hyprland (Wayland compositor)
# =============================================================================
# Hyprland - dynamic tiling Wayland compositor with eye candy effects.
#
# Includes:
#   - Hyprland compositor with XWayland
#   - Greetd + tuigreet (login screen)
#   - XDG portal for Hyprland
#   - Catppuccin cursors
#
# User configuration: Symlinked from home/gars/dots/hypr/hyprland.conf
# Home Manager module: modules/home/hyprland.nix
# =============================================================================
#
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
