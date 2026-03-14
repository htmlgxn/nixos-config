#
# ~/nixos-config/modules/home/gui-base.nix
#
# Common GUI packages for all compositors.
# No compositor-specific dotfile symlinks here — each compositor manages its own config.
# Used by: COSMIC, Hyprland, Niri, River, Wayfire, LabWC, Sway.
#

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ── Terminal ─────────────────────────────────────────────────
    alacritty

    # ── Launcher ─────────────────────────────────────────────────
    fuzzel

    # ── File Explorer ────────────────────────────────────────────
    thunar

    # ── Browser ──────────────────────────────────────────────────
    brave

    # ── Wayland utilities ────────────────────────────────────────
    wlsunset
    wl-clipboard

    # ── Screenshot ───────────────────────────────────────────────
    grim
    flameshot

    # ── Notifications ─────────────────────────────────────────────
    mako

    # ── Status bar ──────────────────────────────────────────────
    waybar

    # ── Lock / Idle ─────────────────────────────────────────────
    swaybg
    swaylock
    swayidle

    # ── System utilities ─────────────────────────────────────────
    polkit_gnome
    brightnessctl
    networkmanagerapplet

    # ── Messengers ───────────────────────────────────────────────
    signal-desktop

    # ── IDE / Code editor ────────────────────────────────────────
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
      ];
    })

    # ── Video editor ─────────────────────────────────────────────
    davinci-resolve
    kdePackages.kdenlive

    # ── Funny ────────────────────────────────────────────────────
    anarchism
  ];

  # ── GTK / QT theming ───────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # ── Cursor theme ──────────────────────────────────────────────────────
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.mochaYellow;
    name = "Catppuccin-Mocha-Yellow-Cursors";
    size = 26;
  };

  # ── Shared dotfile symlinks ─────────────────────────────────────
  home.file = {
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
