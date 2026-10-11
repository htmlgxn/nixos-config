# jtop: Janine's laptop (Intel Panther Lake), GNOME desktop.
# nixos-hardware Intel/laptop modules are added via extraSystemModules in parts/lib.nix.
# Generate hardware-configuration.nix during install (from the NixOS installer):
#   nixos-generate-config --root /mnt --show-hardware-config > hosts/jtop/hardware-configuration.nix
{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./users.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Panther Lake is newer than the default LTS kernel (6.18): its Wi-Fi never
  # binds there, while the installer's 7.x kernel brings it up.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Intel GPU (xe GuC/HuC), audio (SOF) and Wi-Fi firmware come from linux-firmware.
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "jtop";
  networking.networkmanager.enable = true;

  # Printers (discovered over mDNS via the shared Avahi config) and
  # firmware updates surfaced in GNOME Software.
  services.printing.enable = true;
  services.fwupd.enable = true;

  system.stateVersion = "26.05";
}
