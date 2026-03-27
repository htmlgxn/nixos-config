# Core AI coding agents.
{pkgs, ...}: {
  home.packages = with pkgs; [
    qwen-code
    codex
    claude-code
  ];
}
