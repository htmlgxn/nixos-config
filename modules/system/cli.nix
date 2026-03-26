# Shared CLI/TTY system baseline.
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
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
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
