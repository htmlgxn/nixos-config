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
    remotes = {
      "flathub" = {
        url = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        install = lib.mkDefault true;
      };
    };
  };

  # Enable Flatpak support in NixOS
  xdg.portal.enable = true;
}
