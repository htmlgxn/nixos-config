# nixos-vm-specific home-manager configuration.
# Included automatically for every nixos-vm output via hostHomeModules.
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [yt-dlp];

  my.shellAliases.nrs = "nh os switch ${config.my.repoRoot} -H nixos-vm";
}
