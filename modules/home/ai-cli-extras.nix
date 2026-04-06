# Extra AI CLI tools outside the core coding-agent set.
{pkgs, ...}: {
  home.packages = with pkgs; [
    crush
    aichat
    mods # Charmbracelet's AI pipe tool
    shell-gpt # invoked as `sgpt`
    llm # Simon Willison's LLM CLI
    plandex
    #goose-cli
    #aider-chat
    gemini-cli
    mistral-vibe
  ];
}
