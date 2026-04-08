# rpi4-specific home-manager configuration.
# Included automatically for every rpi4 output via hostHomeModules in flake.nix.
# rpi4-specific home-manager configuration.
# Included automatically for every rpi4 output via hostHomeModules.
{config, pkgs, ...}: {
  home.packages = with pkgs; [yt-dlp];

  programs.bash.shellAliases = {
    nrs = "nh os switch ${config.my.repoRoot} -H rpi4-sway";
    nrtty = "nh os switch ${config.my.repoRoot} -H rpi4-tty";
  };

  programs.nushell.shellAliases = {
    nrs = "nh os switch ${config.my.repoRoot} -H rpi4-sway";
    nrtty = "nh os switch ${config.my.repoRoot} -H rpi4-tty";
  };
}
