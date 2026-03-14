#
# ~/nixos-config/modules/home/cli.nix
#

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
  # ── Shell & multiplexer ──────────────────────────────────────────
    tmux
    zellij
  # ── Editor ───────────────────────────────────────────────────────
    neovim
    helix
    # ── AI agent ───────────────────────────────────────────────────
      opencode
      crush
      aichat
      mods       # Charmbracelet's AI pipe tool
      shell-gpt  # invoked as `sgpt`
      llm        # Simon Willison's LLM CLI
      qwen-code
      plandex
      codex
      goose-cli
      aider-chat
      gemini-cli
      mistral-vibe
      # nanocoder - needs llm-agents repo
      kilocode-cli
    # ── Git ───────────────────────────────────────────────────────
      gh
      lazygit
      gitui
  # ── File management ──────────────────────────────────────────────
    lf
    fd
    ripgrep
    bat
    eza
    fzf
    zoxide
    tree
    ranger
  # ── System monitoring ────────────────────────────────────────────
    htop
    btop
    bottom
    powertop
    s-tui
    systemctl-tui
  # ── Networking ───────────────────────────────────────────────────
    rsync
    nmap
    wireguard-tools
    mosh
  # ── Utilities ────────────────────────────────────────────────────
    fend
    ncspot
    glow    # markdown reader
    uv      # python manager
    yt-dlp  # youtube downloader cli 

  # ── Documents / Notes ────────────────────────────────────────────────────
    basalt  # Obsidian CLI

  # ── Test ─────────────────────────────────────────────────────────
    ffmpeg
  ];
}
