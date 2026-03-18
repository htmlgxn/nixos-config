#
# ~/nixos-config/modules/system/gui-base.nix
#
# =============================================================================
# SYSTEM GUI BASE (ALL COMPOSITORS)
# =============================================================================
# Shared system-level GUI configuration for all Wayland compositors.
# Imported by: sway.nix, niri.nix, hyprland.nix
#
# Includes:
#   - Polkit (authentication dialogs)
#   - GNOME Keyring (password manager)
#   - Greetd (login manager with tuigreet)
#   - XDG Portal (file dialogs for GTK apps)
#   - Fonts (Roboto Mono, OpenMoji)
#   - Wayland utilities
#
# Note: PipeWire (audio) is in modules/system/cli.nix for TTY support
#
# TO ADD A NEW COMPOSITOR:
# 1. Create modules/system/<compositor>.nix
# 2. Import this file: imports = [ ./gui-base.nix ];
# 3. Add compositor-specific settings (see sway.nix, niri.nix, hyprland.nix)
# =============================================================================
#
{
  config,
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.greetd.enable = true;

  environment.variables = {
    GTK_THEME = "Adwaita-dark";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  fonts = {
    packages = with pkgs; [
      roboto-mono
      openmoji-color
    ];
  };

  environment.systemPackages = with pkgs; [
    wayland
  ];
}
