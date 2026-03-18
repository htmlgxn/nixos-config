#
# ~/nixos-config/modules/home/cli.nix
#
# =============================================================================
# CLI PACKAGES (ALL USERS)
# =============================================================================
# These packages are installed for ALL users in TTY mode.
#
# To add packages:
#   1. Add to the list below inside `home.packages = with pkgs; [ ... ]`
#   2. Use format: `package-name # optional comment`
#
# To add user-specific packages:
#   - Use modules/home/cli-extras.nix (for gars)
#   - Create modules/home/cli-<name>.nix for other users/devices
#
# Available packages: https://search.nixos.org/packages
# =============================================================================
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
    browsr

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
    # bluetui # when bluetooth support is added

    # ── Media ───────────────────────────────────────────────────────
    ncspot
    yt-dlp
    ffmpeg-full
    cava
    wiki-tui

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
