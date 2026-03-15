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
    # "playwright"
    # add more here
  ];

  # Helper for building Rust packages from crates.io with OpenSSL
  mkRustPackage = {
    pname,
    version,
    crateHash,
    cargoHash,
    doCheck ? false,
    ...
  } @ attrs:
    pkgs.rustPlatform.buildRustPackage (attrs
      // {
        src = pkgs.fetchCrate {
          inherit pname version;
          hash = crateHash;
        };
        inherit cargoHash;
        inherit doCheck;
        nativeBuildInputs = [pkgs.pkg-config];
        buildInputs = [pkgs.openssl];
        OPENSSL_NO_VENDOR = 1;
      });

  outside = mkRustPackage {
    pname = "outside";
    version = "0.5.0";
    crateHash = "sha256-9qTW6xuLYwuNw3cahGdK6zXua8Qpu+NyIRjqsTAmsZI=";
    cargoHash = "sha256-60wgt3/wJ+2lFQN+k2ev0KLSRxiFdxpHtnWILZfHQw0=";
  };

  diskonaut = mkRustPackage {
    pname = "diskonaut-ng";
    version = "0.13.2";
    crateHash = "sha256-3FrdcJxImYpyn5jyJrZF4Haj0JKXNPlrLwIK8A02s1M=";
    cargoHash = "sha256-+NwZbR3fRj8Wi95GtsUQFWOyaZ0ekC4chsoJ5rsH3Zg=";
  };

  domain-check = mkRustPackage {
    pname = "domain-check";
    version = "1.0.1";
    crateHash = "sha256-z4UNTVGLnSLW9gyg4d9xWpLgNhl45rLlK9ARA/YMz3Y=";
    cargoHash = "sha256-KJR/WmSyv4v9ZLEFc/ksVGT3pMBeqAjKZBnvVoP30yk=";
    doCheck = false;
  };
in {
  home.packages = with pkgs; [
    # ── Custom Builds ────────────────────────────────────────────────
    outside
    diskonaut
    domain-check

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

  home.sessionPath = ["$HOME/.local/bin"];

  home.activation.installUvTools = lib.hm.dag.entryAfter ["writeBoundary" "linkGeneration"] ''
    for tool in ${lib.concatStringsSep " " uvTools}; do
      echo "uv: (re)installing $tool..."
      ${pkgs.uv}/bin/uv tool install "$tool" --force \
        --python ${pkgs.python314}/bin/python3
    done
  '';
}
