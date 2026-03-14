#
# ~/nixos-config/modules/home/cli.nix
#

{ config, pkgs, lib, ... }:

let
  uvTools = [
    "ytdl-archiver"
    "ruff"
    # add more here
  ];
in
{
  home.packages = with pkgs; [
    python314
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
    # Local Chat
    ollama-rocm
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

  home.sessionVariables = {
    UV_PYTHON_DOWNLOADS = "never";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.activation.installUvTools = lib.hm.dag.entryAfter [ "writeBoundary" "linkGeneration" ] ''
  for tool in ${lib.concatStringsSep " " uvTools}; do
    echo "uv: (re)installing $tool..."
    ${pkgs.uv}/bin/uv tool install "$tool" --force \
      --python ${pkgs.python314}/bin/python3
  done
'';

}
