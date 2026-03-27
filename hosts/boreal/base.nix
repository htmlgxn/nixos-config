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
}
