{
  services.soft-serve = {
    enable = true;
    settings.auth.admin_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPyzf/Oy8OFx6SK4wxhIgwyzMEXu8tso01ZpfS3WngG"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    23231 # SSH (git clone/push over SSH)
    23232 # HTTP (web UI + HTTP clone)
  ];
}
