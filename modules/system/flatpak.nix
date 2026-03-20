#
# ~/nixos-config/modules/system/flatpak.nix
#
# Flatpak service configuration.
# Enables system-level Flatpak support for sandboxed desktop applications.
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.flatpak = {
    enable = true;
  };

  # Enable Flatpak support in NixOS
  xdg.portal.enable = true;
}
