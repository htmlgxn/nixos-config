#
# ~/nixos-config/modules/home/gui.nix
#

{ config, pkgs, ... }:

{

# ── GUI pkgs ─────────────────────────────────────────────────────
  home.packages = with pkgs; [

  # ── Terminal ─────────────────────────────────────────────────
    alacritty

  # ── Launcher ─────────────────────────────────────────────────
    fuzzel

  # ── File Explorer ────────────────────────────────────────────
    thunar

  # ── Browser ──────────────────────────────────────────────────
    brave

  # ── Wayland custom ───────────────────────────────────────────
    wlsunset

  # ── Wayland GUI ──────────────────────────────────────────────
    waybar
    mako

  # ── Sway pkgs ────────────────────────────────────────────────
    swaybg
    swaylock
    swayidle
    grim
    flameshot

  # ── Messengers ───────────────────────────────────────────────
    signal-desktop

  # ── Video Editor ───────────────────────────────────────────────
    davinci-resolve 

  ];

  # ── Dotfile symlinks ─────────────────────────────────────────
  home.file = {
    ".config/sway/config".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/sway/config";
    ".config/alacritty/alacritty.toml".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/alacritty/alacritty.toml";
    ".config/alacritty/themes/gars-yellow.toml".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/alacritty/themes/gars-yellow.toml";
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
