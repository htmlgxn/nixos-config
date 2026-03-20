#
# ~/nixos-config/modules/home/flatpak.nix
#
# User-level Flatpak package installation.
# Installs Flatpak applications via Home Manager activation.
# Note: Flathub remote is configured by modules/system/flatpak.nix
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  flatpakPackages = import ./flatpak/packages.nix;
in {
  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
  ];

  home.activation.installFlatpaks = lib.hm.dag.entryAfter ["writeBoundary" "linkGeneration"] ''
    for app in ${lib.concatStringsSep " " flatpakPackages}; do
      echo "flatpak: (re)installing $app..."
      ${pkgs.flatpak}/bin/flatpak install --user --noninteractive --assumeyes \
        flathub "$app"
    done
  '';
}
