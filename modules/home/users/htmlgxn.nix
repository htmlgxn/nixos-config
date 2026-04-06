# Home Manager user module for `htmlgxn` (macOS / Fedora hosts).
# home.homeDirectory is set by the output builder (mkDarwinOutput / mkHomeOutput).
{
  config,
  ...
}: let
  userName = "htmlgxn";
in {
  imports = [./common.nix];

  my = {
    primaryUser = userName;
    repoRoot = "${config.home.homeDirectory}/nixos-config";
    dotfilesRoot = "${config.home.homeDirectory}/nixos-config/home/gars";
    dotfilesNixPath = ../../../home/gars;
    containersRoot = "${config.home.homeDirectory}/nixos-config/containers";
    isNixOS = false;
  };

  home.username = userName;

  # Per-user SSH host entries (shared entries are in common.nix):
  # programs.ssh.matchBlocks."myhost" = { ... };
}
