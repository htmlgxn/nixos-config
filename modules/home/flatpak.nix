#
# ~/nixos-config/modules/home/flatpak.nix
#
# User-level Flatpak configuration.
# Adds Flathub remote and manages Flatpak applications via Home Manager.
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.flatpak = {
    enable = true;

    # Add Flathub as the default remote
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };

    # Flatpak applications to install
    packages = [
      "org.flathub.Flathub"
    ];
  };

  # Ensure Flatpak portal is available for sandboxed apps
  xdg.portal.enable = true;
}
