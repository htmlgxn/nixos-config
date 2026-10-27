# AI coding agents, CLI tools, and local inference runtime.
{
  config,
  pkgs,
  lib,
  ...
}: let
  # grok-cli (superagent-ai) and grok-build (xAI) both ship bin/grok; keep
  # `grok` for xAI's grok-build and expose the community CLI as `grok-cli`.
  grok-cli = pkgs.runCommand "grok-cli-${pkgs.grok-cli.version}" {} ''
    mkdir -p $out/bin
    ln -s ${lib.getExe pkgs.grok-cli} $out/bin/grok-cli
  '';
in {
  my.ollamaPackage = lib.mkDefault pkgs.ollama;

  home.packages =
    (lib.optional (config.my.ollamaPackage != null) config.my.ollamaPackage)
    ++ [grok-cli]
    ++ (with pkgs; [
      # Core coding agents
      claude-code
      qwen-code
      #codex
      opencode
      grok-build

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
