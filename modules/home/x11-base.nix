# Shared desktop packages and theming for X11 GUI profiles.
# X11 counterpart to gui-base.nix — imported by dwm.nix and i3.nix.
{
  config,
  pkgs,
  lib,
  ...
}: let
  theme = config.my.guiThemeData;
  resolvePkg = path: builtins.foldl' (pkg: attr: pkg.${attr}) pkgs path;
in {
  imports = [
    ./gui-theme.nix
    ./terminal-theme.nix
    ./xterm.nix
    ./rofi.nix
    ./dunst.nix
  ];

  my.terminal = lib.mkDefault "xterm";

  xsession.enable = true;

  home.packages = with pkgs; [
    # ── Wallpaper ────────────────────────────────────────────────────
    feh

    # ── Screenshots ──────────────────────────────────────────────────
    scrot

    # ── Lock / Idle ──────────────────────────────────────────────────
    xss-lock
    i3lock

    # ── Compositor ───────────────────────────────────────────────────
    picom

    # ── System Utilities ─────────────────────────────────────────────
    brightnessctl
    networkmanagerapplet
    pavucontrol
    xclip

    # ── GTK Theming ──────────────────────────────────────────────────
    gsettings-desktop-schemas
    glib
  ];

  # ── GTK / QT Theming ──────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name = theme.gtk.gtk.theme.name;
      package = resolvePkg theme.gtk.gtk.theme.package;
    };
    iconTheme = {
      name = theme.gtk.gtk.iconTheme.name;
      package = resolvePkg theme.gtk.gtk.iconTheme.package;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = theme.gtk.qt.platformTheme;
    style.name = theme.gtk.qt.style;
  };

  # ── Cursor Theme ──────────────────────────────────────────────────
  home.pointerCursor = {
    gtk.enable = true;
    package = resolvePkg theme.gtk.cursor.package;
    name = theme.gtk.cursor.name;
    size = theme.gtk.cursor.size;
  };
}
