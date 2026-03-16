#
# ~/nixos-config/modules/home/flatpak.nix
#
# User-level Flatpak configuration.
# Adds Flathub remote and installs Flatpak applications via Home Manager.
#
{ config, pkgs, lib, ... }:

let
  flatpakPackages = import ./flatpak/packages.nix;

in {
  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
  ];

  home.activation.installFlatpaks =
    lib.hm.dag.entryAfter [ "writeBoundary" "linkGeneration" ] ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists --user \
        flathub https://dl.flathub.org/repo/flathub.flatpakrepo

      for app in ${lib.concatStringsSep " " flatpakPackages}; do
        echo "flatpak: (re)installing $app..."
        ${pkgs.flatpak}/bin/flatpak install --user --noninteractive --assumeyes \
          flathub "$app"
      done
    '';
}
