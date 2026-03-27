# OpenCode CLI tooling.
{pkgs, ...}: {
  home.packages = with pkgs; [
    opencode
  ];
}
