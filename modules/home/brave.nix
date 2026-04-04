# Brave browser configuration.
# Installs Brave (stable or nightly depending on whether the brave-nightly overlay is applied).
{pkgs, ...}: {
  home.packages = with pkgs; [
    brave
  ];
}
