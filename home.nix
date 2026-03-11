{ config, pkgs, ... }:

{
  home.username = "htmlgxn";
  home.homeDirectory = "/home/htmlgxn";

  home.packages = with pkgs; [
    htop
    tree
    ripgrep
    fd
  ];

  programs.bash.enable = true;

  home.stateVersion = "25.11";
}
