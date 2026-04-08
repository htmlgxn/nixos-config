# fedora-mac-specific home-manager configuration.
# Included automatically for every fedora-mac output via hostHomeModules.
{config, pkgs, ...}: {
  home.packages = with pkgs; [yt-dlp];

  programs.bash.shellAliases.nrs = "nh home switch ${config.my.repoRoot} -c fedora-mac";
  programs.nushell.shellAliases.nrs = "nh home switch ${config.my.repoRoot} -c fedora-mac";
}
