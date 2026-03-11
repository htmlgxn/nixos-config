{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell & multiplexer
    tmux
    zellij
    # Editor
    neovim
    helix
    # File management
    lf
    fd
    ripgrep
    bat
    eza
    fzf
    zoxide
    # System monitoring
    htop
    btop
    nvtop
    powertop
    s-tui
    # Networking
    wget
    curl
    rsync
    nmap
    wireguard-tools
    mosh
  ];
}
