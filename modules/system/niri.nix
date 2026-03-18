#
# ~/nixos-config/modules/system/niri.nix
#
# =============================================================================
# SYSTEM CONFIGURATION: Niri (scrollable-tiling Wayland compositor)
# =============================================================================
# Niri - scrollable-tiling Wayland compositor (Smithay-based).
#
# Notable:
#   - No built-in XWayland. Use xwayland-satellite as a workaround.
#   - Config is NOT managed by Nix - symlinked from ~/dots/niri/config.kdl
#
# Includes:
#   - Niri compositor
#   - Greetd + tuigreet (login screen)
#   - xwayland-satellite (X11 app support)
#   - slurp (region selector)
#   - swaybg, swaylock (background, lock screen)
#   - Catppuccin cursors
#
# User configuration: Symlinked from home/gars/dots/niri/config.kdl
# Home Manager module: modules/home/niri.nix
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

  programs.niri.enable = true;

  programs.dconf.enable = true;

  services.greetd.settings.default_session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
    user = "greeter";
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
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

  environment.variables = {
    XCURSOR_THEME = "Catppuccin-Mocha-Yellow-Cursors";
    XCURSOR_SIZE = "26";
  };
}
