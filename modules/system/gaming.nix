# Shared system gaming support.
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Steam platform
  programs.steam = {
    enable = true;

    # Enable remote play (streaming to other devices)
    remotePlay.openFirewall = true;

    # Enable Steam Play (Proton) for all games
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    steam
    # Add more gaming packages here
  ];
}
