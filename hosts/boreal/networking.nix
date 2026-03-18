#
# ~/nixos-config/hosts/boreal/networking.nix
#
{...}: {
  networking.hostName = "boreal";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8096 2200];
  };
}
