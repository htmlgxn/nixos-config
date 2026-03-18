#
# ~/nixos-config/modules/system/cli.nix
#
# =============================================================================
# SYSTEM-WIDE CLI CONFIGURATION (ALL HOSTS, TTY & GUI)
# =============================================================================
# System-level packages and services for CLI/TTY mode.
# Imported by all hosts (boreal, nixos-vm, cyberdeck, etc.)
#
# To add system packages:
#   1. Add to `environment.systemPackages = with pkgs; [ ... ]` below
#   2. These are available to ALL users on the system
#
# To add host-specific system packages:
#   - Edit hosts/<hostname>/configuration.nix
#
# Services configured:
#   - SSH (port 2200)
#   - PipeWire (audio server - works in TTY, needed for Bluetooth/multi-app audio)
# =============================================================================
#
{
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      Port = 2200;
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # PipeWire audio server - enables audio in TTY mode
  # Required for: Bluetooth audio, multi-app audio, pavucontrol
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    file
    unzip
    zip
  ];
}
