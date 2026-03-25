# AI agent CLI tools.
# Included via extraHomeModules on outputs that want the full AI toolkit.
{pkgs, ...}: {
  home.packages = with pkgs; [
    opencode
    crush
    aichat
    mods # Charmbracelet's AI pipe tool
    shell-gpt # invoked as `sgpt`
    llm # Simon Willison's LLM CLI
    qwen-code
    plandex
    codex
    goose-cli
    aider-chat
    gemini-cli
    mistral-vibe
    # nanocoder - needs llm-agents repo
  ];
}
