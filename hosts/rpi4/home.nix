# rpi4-specific home-manager configuration.
# Included automatically for every rpi4 output via hostHomeModules in flake.nix.
_: {
  programs.bash.shellAliases = {
    nrs = "nh os switch . -H rpi4-sway";
    nrtty = "nh os switch . -H rpi4-tty";
  };

  programs.nushell.shellAliases = {
    nrs = "nh os switch . -H rpi4-sway";
    nrtty = "nh os switch . -H rpi4-tty";
  };
}
