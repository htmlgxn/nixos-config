#
# ~/nixos-config/modules/system/sway.nix
#
# =============================================================================
# SYSTEM CONFIGURATION: Sway (Wayland compositor)
# =============================================================================
# Sway - i3-compatible Wayland compositor.
# Production compositor for boreal host.
#
# Includes:
#   - Sway with GTK wrapper
#   - Greetd + tuigreet (login screen)
#   - XWayland (X11 app support)
#   - wofi (application launcher)
#   - Fonts (TODO: change to match gui-base.nix: Roboto Mono + OpenMoji)
#
# User configuration: ~/.config/sway/config
# Home Manager module: modules/home/sway.nix
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
