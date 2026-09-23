# Shared CLI/TTY system baseline.
_: {
  services.openssh = {
    enable = true;
    # `ports` (not settings.Port) drives both sshd's Port lines and openFirewall;
    # setting only settings.Port left the default port 22 listening and open.
    ports = [2200];
    settings = {
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
}
