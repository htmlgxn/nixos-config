# Shared Home Manager CLI package set.
{
  config,
  pkgs,
  lib,
  ...
}: let
  emojiTools = import ./emoji-tools.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    # ── Shell & Multiplexer ─────────────────────────────────────────
    tmux
    zellij
    sl
    netcat-gnu

    # ── Nix Tooling ────────────────────────────────────────────────
    nix-search-tv
    alejandra # nix formatter
    nix-tree

    # ── Neovim Tooling ─────────────────────────────────────────────
    nodePackages.bash-language-server
    nodePackages.vscode-langservers-extracted
    lua-language-server
    marksman
    nixd
    stylua
    shfmt
    jq
    prettier

    # ── Editor ──────────────────────────────────────────────────────
    neovim
    helix

    # ── Git ─────────────────────────────────────────────────────────
    git
    gh
    lazygit
    gitui

    # ── File Management ─────────────────────────────────────────────
    lf
    fd
    ripgrep
    bat
    emojiTools.emojiPickerCli
    eza
    fzf
    television
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
