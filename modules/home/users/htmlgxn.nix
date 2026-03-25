# Home Manager user module for `htmlgxn` (macOS / Fedora hosts).
# home.homeDirectory is set by the output builder (mkDarwinOutput / mkHomeOutput).
{
  config,
  pkgs,
  lib,
  ...
}: let
  userName = "htmlgxn";
in {
  imports = [./gars-common.nix];

  my = {
    primaryUser = userName;
    repoRoot = "${config.home.homeDirectory}/nixos-config";
    dotfilesRoot = "${config.home.homeDirectory}/nixos-config/home/gars";
    containersRoot = "${config.home.homeDirectory}/nixos-config/containers";
    isNixOS = false;
    ollamaPackage = pkgs.ollama;
  };

  home.username = userName;

  programs.bash = {
    shellAliases = {
      eh = "nvim ${config.my.repoRoot}/modules/home/users/htmlgxn.nix";
    };
  };
}
