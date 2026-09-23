# boreal networking and firewall settings.
_: {
  networking.hostName = "boreal";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    # Soft Serve ports are opened by modules/system/soft-serve.nix.
    allowedTCPPorts = [8096 2200];
  };
}
