# Core boreal host defaults.
{pkgs, ...}: {
  programs.nix-ld.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "vm.swappiness" = 20;
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Logitech Unifying/Bolt receiver (MX Master): udev rules for receiver
  # access plus Solaar for pairing, battery level, and button config.
  hardware.logitech.wireless.enable = true;
  programs.solaar.enable = true;

  # Keychron vendor ID (Browser HID)
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0660", GROUP="users", TAG+="uaccess"
  '';
}
