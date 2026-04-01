# boreal networking and firewall settings.
{...}: {
  networking.hostName = "boreal";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8096 2200 23231 23232];
  };

  # MediaTek MT7921 (TP-Link AC600) - disable ASPM to prevent disconnections
  # Known issue: https://github.com/NixOS/nixpkgs/issues/444538
  boot.kernelParams = ["mt7921e.disable_aspm=1"];
}
