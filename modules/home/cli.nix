# Shared Home Manager CLI package set.
{
  config,
  pkgs,
  lib,
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
      emojiTools.emojiPickerCli
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
      s-tui
      systemctl-tui
      gdu

      # ── Networking ──────────────────────────────────────────────────
      rsync
      nmap
      wireguard-tools
      mosh
      k9s
      proton-vpn-cli
      # bluetui # when bluetooth support is added

      # ── Mesh Networking ─────────────────────────────────────────────
      contact # Meshtastic TUI

      # ── Media ───────────────────────────────────────────────────────
      ncspot
      yt-dlp
      ffmpeg-full
      cava
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
    ]
    # ── Linux-only ──────────────────────────────────────────────────
    ++ lib.optionals pkgs.stdenv.isLinux [
      powertop
    ]
    # ── Local Chat (host-selected variant) ──────────────────────────
    ++ lib.optionals (config.my.ollamaPackage != null) [
      config.my.ollamaPackage
    ];

  programs.nh = {
    enable = true;
    flake = "/home/gars/nixos-config"; # or wherever $_nixcfg_repo points

    # Optional: automated GC via nh clean instead of nix.gc
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
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
