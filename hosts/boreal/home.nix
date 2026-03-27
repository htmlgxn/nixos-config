# boreal-specific home-manager configuration.
# Included automatically for every boreal output via hostHomeModules in flake.nix.
{pkgs, ...}: {
  # boreal connects to itself — use localhost instead of boreal.local.
  my.borealHost = "localhost";

  home.packages = with pkgs; [alacritty];

  programs.ssh.matchBlocks."rpi4" = {
    hostname = "rpi4.local";
    port = 2200;
    user = "gars";
    addressFamily = "inet";
    identityFile = "~/.ssh/id_ed25519";
    identitiesOnly = true;
  };
}
