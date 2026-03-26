{
  services.soft-serve = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    23231 # SSH (git clone/push over SSH)
    23232 # HTTP (web UI + HTTP clone)
  ];
}
