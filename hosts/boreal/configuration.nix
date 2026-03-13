#
# ~/nixos-config/hosts/boreal/configuration.nix
#

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ── Boot ──────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable         = true;
  boot.loader.efi.canTouchEfiVariables    = true;
  boot.loader.efi.efiSysMountPoint        = "/efi";
  boot.kernelPackages                     = pkgs.linuxPackages_latest;

  # AMD RX 570 — load amdgpu early for proper modesetting
  boot.initrd.kernelModules               = [ "amdgpu" ];
  services.xserver.videoDrivers          = [ "amdgpu" ];

  # Test for Resolve
  hardware.amdgpu.opencl.enable = true;

  # ── Hardware ──────────────────────────────────────────────────────────
  hardware.graphics = {
    enable       = true;
    enable32Bit  = true;   # needed for Steam / 32-bit OpenGL
    extraPackages = with pkgs; [
      mesa.opencl # Rusticl OpenCL support for RX 570
    ];  
  };

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  # ── Network ───────────────────────────────────────────────────────────
  networking.hostName             = "boreal";
  networking.networkmanager.enable = true;

  # ── Locale & Time ─────────────────────────────────────────────────────
  time.timeZone       = "America/Halifax";
  i18n.defaultLocale  = "en_CA.UTF-8";

  # ── Users ─────────────────────────────────────────────────────────────
  users.users.gars = {
    isNormalUser    = true;
    extraGroups     = [ "wheel" "networkmanager" "video" "audio" "render" ];
    initialPassword = "changeme";
  };

  # ── Base system packages ──────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    file
    unzip
    zip
  ];

  # ── Nix ───────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
  automatic = true;
  dates     = "weekly";
  options   = "--delete-older-than 30d"; # store can grow fast with multiple configs
};

  # See: https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.11";
}
