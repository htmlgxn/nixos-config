# Shared system gaming support.
{pkgs, ...}: {
  # Steam platform
  programs.steam = {
    enable = true;

    # Enable remote play (streaming to other devices)
    remotePlay.openFirewall = true;

    # Enable Steam Play (Proton) for all games
    extraCompatPackages = [pkgs.proton-ge-bin];
  };
}
