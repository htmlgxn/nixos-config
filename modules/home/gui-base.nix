# Shared desktop packages and theming for full GUI profiles.
{
  config,
  pkgs,
  ...
}: let
  waybarCfg = import ./waybar-settings.nix {inherit pkgs config;};
  theme = config.my.guiThemeData;
  # Helper to resolve package from list of attribute names (e.g., ["catppuccin-cursors" "mochaYellow"])
  resolvePkg = path: builtins.foldl' (pkg: attr: pkg.${attr}) pkgs path;
in {
  imports = [
    ./gui-theme.nix
    ./terminal-theme.nix
    ./alacritty.nix
    ./kitty.nix
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
    kitty
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
