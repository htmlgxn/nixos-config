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
    xfce.thunar
  ];

  # Symlink dotfiles into place
  home.file = {
    ".config/sway/config".source =
      config.lib.file.mkOutOfStoreSymlink "/home/htmlgxn/nixos-config/home/htmlgxn/dots/sway/config";
    ".config/waybar/config".source =
      config.lib.file.mkOutOfStoreSymlink "/home/htmlgxn/nixos-config/home/htmlgxn/dots/waybar/config";
    ".config/waybar/style.css".source =
      config.lib.file.mkOutOfStoreSymlink "/home/htmlgxn/nixos-config/home/htmlgxn/dots/waybar/style.css";
    ".config/fuzzel/fuzzel.ini".source =
      config.lib.file.mkOutOfStoreSymlink "/home/htmlgxn/nixos-config/home/htmlgxn/dots/fuzzel/fuzzel.ini";
    ".config/mako/config".source =
      config.lib.file.mkOutOfStoreSymlink "/home/htmlgxn/nixos-config/home/htmlgxn/dots/mako/config";
  };
}
