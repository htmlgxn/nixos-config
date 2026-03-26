# Core boreal host defaults.
{pkgs, ...}: {
  programs.nix-ld.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "America/Halifax";
  i18n.defaultLocale = "en_CA.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 20;
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
