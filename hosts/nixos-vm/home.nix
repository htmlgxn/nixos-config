# nixos-vm-specific home-manager configuration.
# Included automatically for every nixos-vm output via hostHomeModules in flake.nix.
_: {
  programs.bash.shellAliases = {
    nrs = "nh os switch . -H nixos-vm";
  };

  programs.nushell.shellAliases = {
    nrs = "nh os switch . -H nixos-vm";
  };
}
