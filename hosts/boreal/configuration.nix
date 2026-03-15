#
# ~/nixos-config/hosts/boreal/configuration.nix
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # To sort / organize
  programs.nix-ld.enable = true;

  # ── Boot ──────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # AMD RX 570 — load amdgpu early for proper modesetting
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  # Test for Resolve (deprecated ?)
  #hardware.amdgpu.opencl.enable = true;

  # ── Hardware ──────────────────────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # needed for Steam / 32-bit OpenGL
    extraPackages = with pkgs; [
      mesa.opencl # Rusticl OpenCL support for RX 570
    ];
  };

  # ── Filesystems ───────────────────────────────────────────────────────
  swapDevices = [
    {device = "/home/swapfile"; size = 16384; priority = 10;}
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 25; # ~8GB on a 32GB system
    priority = 100;
  };

  fileSystems."/mnt/archive" = {
    device = "/dev/disk/by-uuid/316d561a-dfc9-4269-a887-8644819b207e";
    fsType = "ext4";
  };

  fileSystems."/mnt/seagate6" = {
    device = "/dev/disk/by-uuid/f248cacf-47ad-4d45-bf3e-04d8a991153c";
    fsType = "ext4";
  };

  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/d3d01560-2003-4e11-88be-cc87f3448c83";
    fsType = "ext4";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/archive 0755 gars users - -"
    "d /mnt/seagate6 0755 gars users - -"
    "d /mnt/backup 0755 gars users - -"
  ];

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
    ROC_ENABLE_PRE_VEGA = "1";
    QT_QPA_PLATFORM = "xcb";
  };

  # ── Network ───────────────────────────────────────────────────────────
  networking.hostName = "boreal";
  networking.networkmanager.enable = true;

  # ── Locale & Time ─────────────────────────────────────────────────────
  time.timeZone = "America/Halifax";
  i18n.defaultLocale = "en_CA.UTF-8";

  # ── Users ─────────────────────────────────────────────────────────────
  users.users.gars = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "render"];
    initialPassword = "changeme";
  };

  # ── Nix ───────────────────────────────────────────────────────────────
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d"; # store can grow fast with multiple configs
  };

  # ── Memory ────────────────────────────────────────────────────────────
  boot.kernel.sysctl = {
    "vm.swappiness" = 20;
  };

  # See: https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.11";
}
