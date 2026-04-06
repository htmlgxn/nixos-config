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

  # Gaming packages
  # Note: Steam itself is installed via programs.steam above
  environment.systemPackages = with pkgs; [
    # Add more gaming packages here
  ];
}
