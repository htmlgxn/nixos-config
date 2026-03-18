#
# ~/nixos-config/modules/home/gui-base.nix
#
# =============================================================================
# GUI BASE PACKAGES (ALL USERS, ALL COMPOSITORS)
# =============================================================================
# Common GUI packages shared across all Wayland compositors (Sway, Niri, Hyprland).
#
# Includes: terminal, browser, file manager, waybar, notifications, theming, etc.
#
# To add GUI packages:
#   1. Add to `home.packages = with pkgs; [ ... ]` below
#   2. For compositor-specific packages, use modules/home/<compositor>.nix
#
# Compositor-specific configs:
#   - modules/home/sway.nix
#   - modules/home/niri.nix
#   - modules/home/hyprland.nix
# =============================================================================
#
{
  config,
  pkgs,
  ...
}: let
  waybarCfg = import ./waybar-settings.nix {inherit pkgs;};
in {
  imports = [
    ./alacritty.nix
    ./fuzzel.nix
    ./mako.nix
  ];

  programs.waybar = {
    enable = true;
    style = waybarCfg.style;
  };

  home.packages = with pkgs; [
    # ── Terminal & Launcher ─────────────────────────────────────────
    alacritty
    fuzzel

    # ── File & Web ──────────────────────────────────────────────────
    thunar
    firefox

    # ── Wayland Utilities ───────────────────────────────────────────
    wlsunset
    wl-clipboard

    # ── GTK Theming ─────────────────────────────────────────────────
    gsettings-desktop-schemas
    glib # provides gsettings binary

    # ── Screenshot ──────────────────────────────────────────────────
    grim

    # ── Notifications ───────────────────────────────────────────────
    mako

    # ── Status Bar ──────────────────────────────────────────────────
    waybar

    # ── Lock / Idle ─────────────────────────────────────────────────
    swaybg
    swaylock
    swayidle

    # ── System Utilities ────────────────────────────────────────────
    polkit_gnome
    brightnessctl
    networkmanagerapplet
    pavucontrol

    # ── Messengers ──────────────────────────────────────────────────
    signal-desktop

    # ── Media ───────────────────────────────────────────────────────
    mpv

    # ── Documents & Notes ───────────────────────────────────────────
    obsidian
    libreoffice-fresh

    # ── IDE & Code Editor ───────────────────────────────────────────
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = let
        # Extensions from nixpkgs
        nixpkgsExtensions = with vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh
          asvetliakov.vscode-neovim
        ];
        # Extensions from marketplace (not in nixpkgs)
        marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.47.2";
            sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
          }
        ];
      in
        nixpkgsExtensions ++ marketplaceExtensions;
    })

    # ── Video Editor ────────────────────────────────────────────────
    kdePackages.kdenlive

    # ── Misc ────────────────────────────────────────────────────────
    qbittorrent
    #kicad-testing
    freecad
    anarchism
  ];

  # ── Brave with Symlinks + Extensions ──────────────────────────────
  programs.brave = {
    enable = true;
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "aapbdbdomjkkjkaonfhkkikfgjllcleb";} # Google Translate
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # SponsorBlock (YouTube)
      {id = "cclelndahbckbenkjhflpdbgdldlbecc";} # Get cookies.txt LOCALLY
      {id = "bhlhnicpbhignbdhedgjhgdocnmhomnp";} # ColorZilla
      {id = "ilehaonighjijnmpnagapkhpcdbhclfg";} # Grass Lite Node
    ];
  };

  # ── GTK / QT Theming ──────────────────────────────────────────────
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

  # ── Cursor Theme ──────────────────────────────────────────────────
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.mochaYellow;
    name = "Catppuccin-Mocha-Yellow-Cursors";
    size = 26;
  };
}
