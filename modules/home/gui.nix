#
# ~/nixos-config/modules/home/gui.nix
#

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty
    fuzzel
    waybar
    mako
    swaybg
    swaylock
    swayidle
    wlsunset
    grim
    flameshot
    brave
    thunar
  ];

  # Symlink dotfiles into place
  home.file = {
    ".config/sway/config".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/sway/config";
    ".config/waybar/config".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/waybar/config";
    ".config/waybar/style.css".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/waybar/style.css";
    ".config/fuzzel/fuzzel.ini".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/fuzzel/fuzzel.ini";
    ".config/mako/config".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/mako/config";
  };
}
