# AI coding agents, CLI tools, and local inference runtime.
{
  config,
  pkgs,
  lib,
  ...
}: {
  my.ollamaPackage = lib.mkDefault pkgs.ollama;

  home.packages =
    [
      config.my.ollamaPackage
    ]
    ++ (with pkgs; [
      # Core coding agents
      claude-code
      qwen-code
      codex
      opencode

      # Extra AI CLI tools
      # crush
      # aichat
      # mods
      # shell-gpt
      # llm
      # plandex
      # gemini-cli
      # mistral-vibe
    ]);
}
