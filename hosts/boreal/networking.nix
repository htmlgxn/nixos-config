# boreal networking and firewall settings.
{...}: {
  networking.hostName = "boreal";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8096];
    # allowedTCPPorts = [8096 2200];
  };
}
