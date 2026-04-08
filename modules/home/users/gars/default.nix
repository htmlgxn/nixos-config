# Primary Home Manager user module for `gars` (NixOS / Linux hosts).
_: let
  userName = "gars";
  homeDir = "/home/${userName}";
in {
  imports = [../common.nix];

  my = {
    primaryUser = userName;
    repoRoot = "${homeDir}/nixos-config";
    containersRoot = "${homeDir}/nixos-config/containers";
  };

  home = {
    username = userName;
    homeDirectory = homeDir;
  };

  home.stateVersion = "26.05";
}
