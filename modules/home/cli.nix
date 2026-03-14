#
# ~/nixos-config/modules/home/cli.nix
#

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ── Shell & Multiplexer ─────────────────────────────────────────
    tmux
    zellij

    # ── Editor ──────────────────────────────────────────────────────
    neovim
    helix

    # ── AI Agents ───────────────────────────────────────────────────
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

    # ── Git ─────────────────────────────────────────────────────────
    gh
    lazygit
    gitui

    # ── File Management ─────────────────────────────────────────────
    lf
    fd
    ripgrep
    bat
    eza
    fzf
    zoxide
    tree
    ranger

    # ── System Monitoring ───────────────────────────────────────────
    htop
    btop
    bottom
    powertop
    s-tui
    systemctl-tui

    # ── Networking ──────────────────────────────────────────────────
    rsync
    nmap
    wireguard-tools
    mosh

    # ── Media ───────────────────────────────────────────────────────
    ncspot
    yt-dlp
    ffmpeg-full

    # ── Calculator & Notes ──────────────────────────────────────────
    fend
    glow    # markdown reader
    basalt  # Obsidian CLI

    # ── Development ─────────────────────────────────────────────────
    uv      # python manager
  ];
}
