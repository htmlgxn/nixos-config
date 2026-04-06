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
      vim
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
      alejandra # nix formatter
      nix-tree
      deadnix
      statix

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

  # yazi
  programs.yazi = {
    enable = true;
    plugins = with pkgs.yaziPlugins; {
      inherit git starship jump-to-char;
    };
  };
}
