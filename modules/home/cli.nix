#
# ~/nixos-config/modules/home/cli.nix
#
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # ── Shell & Multiplexer ─────────────────────────────────────────
    tmux
    zellij

    # ── Editor ──────────────────────────────────────────────────────
    neovim
    helix

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
    broot
    zoxide
    tree
    ranger
    dust

    # ── System Monitoring ───────────────────────────────────────────
    htop
    btop
    bottom
    powertop
    s-tui
    systemctl-tui
    gdu

    # ── Networking ──────────────────────────────────────────────────
    rsync
    nmap
    wireguard-tools
    mosh
    k9s

    # ── Media ───────────────────────────────────────────────────────
    ncspot
    yt-dlp
    ffmpeg-full
    cava

    # ── Calculator & Notes ──────────────────────────────────────────
    fend
    glow # markdown reader
    basalt # Obsidian CLI
    dijo # habit tracker

    # ── Fetch ───────────────────────────────────────────────────────
    fastfetch
    countryfetch

    # ── Development ─────────────────────────────────────────────────
    alejandra # nix formatter
    nix-tree

    # ── AI Agents ───────────────────────────────────────────────────
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
    kilocode-cli
    # Local Chat
    ollama-rocm
  ];
}
