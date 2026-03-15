#
# ~/nixos-config/modules/home/cli.nix
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  uvTools = [
    "ytdl-archiver"
    # add more here
  ];

  outside = pkgs.rustPlatform.buildRustPackage rec {
    pname = "outside";
    version = "0.5.0";

    src = pkgs.fetchCrate {
      inherit pname version;
      hash = "sha256-9qTW6xuLYwuNw3cahGdK6zXua8Qpu+NyIRjqsTAmsZI=";
    };

    cargoHash = "sha256-60wgt3/wJ+2lFQN+k2ev0KLSRxiFdxpHtnWILZfHQw0=";

    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.openssl];

    OPENSSL_NO_VENDOR = 1;
  };
  
  diskonaut = pkgs.rustPlatform.buildRustPackage rec {
    pname = "diskonaut-ng";
    version = "0.13.2";

    src = pkgs.fetchCrate {
      inherit pname version;
      hash = "sha256-3FrdcJxImYpyn5jyJrZF4Haj0JKXNPlrLwIK8A02s1M=";
    };

    cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    nativeBuildInputs = [pkgs.pkg-config];
    # buildInputs = [pkgs.openssl];

    # OPENSSL_NO_VENDOR = 1;
  };

in {
  home.packages = with pkgs; [
    python314
    # ── Custom Builds ────────────────────────────────────────────────
    outside
    diskonaut

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
    # diskonaut - to add

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
    cava

    # ── Calculator & Notes ──────────────────────────────────────────
    fend
    glow   # markdown reader
    basalt # Obsidian CLI
    dijo   # habit tracker

    # ── Extra ───────────────────────────────────────────────────────
    countryfetch

    # ── Development ─────────────────────────────────────────────────
    uv         # python manager
    alejandra  # nix formatter

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
  ];

  home.sessionVariables = {
    UV_PYTHON_DOWNLOADS = "never";
  };

  home.sessionPath = ["$HOME/.local/bin"];

  home.activation.installUvTools = lib.hm.dag.entryAfter ["writeBoundary" "linkGeneration"] ''
    for tool in ${lib.concatStringsSep " " uvTools}; do
      echo "uv: (re)installing $tool..."
      ${pkgs.uv}/bin/uv tool install "$tool" --force \
        --python ${pkgs.python314}/bin/python3
    done
  '';
}
