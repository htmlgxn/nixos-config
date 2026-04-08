# Home Manager user module for `htmlgxn` (macOS / Fedora hosts).
# home.homeDirectory is set by the output builder (mkDarwinOutput / mkHomeOutput).
{
  config,
  lib,
  ...
}: let
  userName = "htmlgxn";
in {
  imports = [./common.nix];

  my = {
    primaryUser = userName;
    repoRoot = "${config.home.homeDirectory}/nixos-config";
    containersRoot = "${config.home.homeDirectory}/nixos-config/containers";
  };

  home = {
    username = userName;
    homeDirectory = lib.mkDefault "/home/${userName}";
    stateVersion = "26.05";
  };
}
