# fedora-mac-specific home-manager configuration.
# Included automatically for every fedora-mac output via hostHomeModules.
{config, ...}: {
  # home.packages = with pkgs; [yt-dlp];

  my.shellAliases.nrs = "nh home switch -b bak ${config.my.repoRoot} -c fedora-mac";
}
