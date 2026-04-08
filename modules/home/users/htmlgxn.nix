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
    dotfilesRoot = "${config.home.homeDirectory}/nixos-config/home/gars";
    dotfilesNixPath = ../../../home/gars;
    containersRoot = "${config.home.homeDirectory}/nixos-config/containers";
    isNixOS = false;
  };

  home.username = userName;
  home.homeDirectory = lib.mkDefault "/home/${userName}";
  home.stateVersion = "26.05";

  # ── macOS SSH entries ───────────────────────────────────────────────
  programs.ssh.matchBlocks."github.com" = {
    hostname = "github.com";
    extraOptions = {
      AddKeysToAgent = "yes";
      UseKeychain = "yes";
    };
    identityFile = "~/.ssh/id_ed25519";
  };
}
