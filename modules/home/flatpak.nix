#
# ~/nixos-config/modules/home/flatpak.nix
#
# User-level Flatpak apps via nix-flatpak: adds the Flathub remote and installs
# the apps in ./flatpak/packages.nix from a systemd user unit (idempotent; no
# network access during activation). The system side is modules/system/flatpak.nix.
#
{
  config,
  inputs,
  ...
}: {
  imports = [inputs.nix-flatpak.homeManagerModules.nix-flatpak];

  services.flatpak = {
    packages = import ./flatpak/packages.nix;
    # Apps installed by hand with `flatpak install --user` are left alone.
    uninstallUnmanaged = false;
  };

  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
  ];
}
