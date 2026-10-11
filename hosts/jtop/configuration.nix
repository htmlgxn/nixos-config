# jtop: Janine's laptop (Intel Core 5), GNOME desktop.
# nixos-hardware Intel/laptop modules are added via extraSystemModules in parts/lib.nix.
# Generate hardware-configuration.nix during install (from the NixOS installer):
#   nixos-generate-config --root /mnt --show-hardware-config > hosts/jtop/hardware-configuration.nix
{
  imports = [
    ./hardware-configuration.nix
    ./users.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Intel Wi-Fi (iwlwifi) and GPU (GuC/HuC/DMC) need linux-firmware; without
  # it there is no wlan device and GDM never comes up.
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "jtop";
  networking.networkmanager.enable = true;

  # Printers (discovered over mDNS via the shared Avahi config) and
  # firmware updates surfaced in GNOME Software.
  services.printing.enable = true;
  services.fwupd.enable = true;

  system.stateVersion = "26.05";
}
