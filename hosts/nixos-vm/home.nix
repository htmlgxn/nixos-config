# nixos-vm-specific home-manager configuration.
# Included automatically for every nixos-vm output via hostHomeModules in flake.nix.
# nixos-vm-specific home-manager configuration.
# Included automatically for every nixos-vm output via hostHomeModules.
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [yt-dlp];

  programs.bash.shellAliases.nrs = "nh os switch ${config.my.repoRoot} -H nixos-vm";
  programs.nushell.shellAliases.nrs = "nh os switch ${config.my.repoRoot} -H nixos-vm";
}
