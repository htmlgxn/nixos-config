# Core AI coding agents.
{pkgs, ...}: {
  home.packages = with pkgs; [
    claude-code
    qwen-code
    codex
    opencode
  ];
}
