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
