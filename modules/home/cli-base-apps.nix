# Shared Home Manager CLI package set.
{
  pkgs,
  lib,
  inputs,
  ...
}: let
  emojiTools = import ./emoji-tools.nix {inherit pkgs;};
in {
  home.packages = with pkgs;
    [
      # Defaults
      git
      wget
      curl
      file
      unzip
      zip
      gocryptfs
      usbutils
      gptfdisk

      # ── Shell & Multiplexer ─────────────────────────────────────────
      tmux
      zellij
      sl
      netcat-gnu

      # ── Nix Tooling ────────────────────────────────────────────────
      nix-search-tv
      nix-tree

      # ── Neovim LSP & Formatters ───────────────────────────────────
      # Formatters are also configured repo-wide via treefmt (parts/treefmt.nix)
      # but neovim needs them on PATH for conform.nvim
      lua-language-server
      marksman
      nixd
      alejandra
      statix
      deadnix
      shellcheck
      markdownlint-cli2
      stylua
      shfmt
      jq
      prettier

      # ── Editor ──────────────────────────────────────────────────────
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
      eza
      fzf
      television
      broot
      # zoxide — managed via programs.zoxide below
      tree
      ranger
      dust
      browsr

      # ── System Monitoring ───────────────────────────────────────────
      htop
      btop
      bottom
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
      wiki-tui
      #telescope # telescope and amfora are gemini browsers
      #amfora

      # ── Calculator & Notes ──────────────────────────────────────────
      fend
      glow # markdown reader
      frogmouth
      md-tui
      basalt # Obsidian CLI
      dijo # habit tracker

      # ── Fetch ───────────────────────────────────────────────────────
      countryfetch

      # ── Books ───────────────────────────────────────────────────────
      (inputs.bookokrat.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {doCheck = false;}))
    ]
    # ── Linux-only ──────────────────────────────────────────────────
    ++ lib.optionals pkgs.stdenv.isLinux [
      emojiTools.emojiPickerCli
      s-tui
      systemctl-tui
      proton-vpn-cli
      cava
      contact # Meshtastic TUI
      powertop
    ];

  programs.nh = {
    enable = true;
    flake = "config.my.repoRoot";
    # Automated GC via nh clean instead of nix.gc
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 3 --keep-since 1d";
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };

  # yazi
  programs.yazi = {
    enable = true;
    plugins = with pkgs.yaziPlugins; {
      inherit git starship jump-to-char;
    };
  };
}
