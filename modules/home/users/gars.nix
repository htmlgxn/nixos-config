# Primary Home Manager user module for `gars` (NixOS / Linux hosts).
_: let
  userName = "gars";
  homeDir = "/home/${userName}";
in {
  imports = [./common.nix];

  my = {
    primaryUser = userName;
    repoRoot = "${homeDir}/nixos-config";
    dotfilesRoot = "${homeDir}/nixos-config/home/${userName}";
    dotfilesNixPath = ../../../home/gars;
    containersRoot = "${homeDir}/nixos-config/containers";
    wallpaper = "${homeDir}/nixos-config/home/${userName}/wallpapers/default.jpg";
  };

  home.username = userName;
  home.homeDirectory = homeDir;

  # Per-user SSH host entries (shared entries are in common.nix):
  # programs.ssh.matchBlocks."myhost" = { ... };

  home.stateVersion = "26.05";
}
