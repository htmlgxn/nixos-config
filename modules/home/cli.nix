#
# ~/nixos-config/modules/home/cli.nix
#

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
    tree
    ranger
    # System monitoring
    htop
    btop
    bottom
    powertop
    s-tui
    systemctl-tui
    # Networking
    rsync
    nmap
    wireguard-tools
    mosh
    # Utilities
    fend
    ncspot
    gh   # github cli
    glow # markdown reader
  ];
}
