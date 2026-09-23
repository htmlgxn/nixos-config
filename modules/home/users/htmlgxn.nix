# Home Manager user module for `htmlgxn` (macOS / Fedora hosts).
{
  config,
  pkgs,
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
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Users/${userName}"
      else "/home/${userName}";
    stateVersion = "26.05";
  };
}
