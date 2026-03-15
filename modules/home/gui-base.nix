#
# ~/nixos-config/modules/home/gui-base.nix
#
# Common GUI packages for all compositors.
# No compositor-specific dotfile symlinks here — each compositor manages its own config.
# Used by: Sway, and Niri.
#

{ config, pkgs, ... }:
let
  outside = pkgs.rustPlatform.buildRustPackage rec {
    pname = "outside";
    version = "0.5.0";

    src = pkgs.fetchCrate {
      inherit pname version;
      hash = "sha256-9qTW6xuLYwuNw3cahGdK6zXua8Qpu+NyIRjqsTAmsZI=";
    };

    cargoHash = "sha256-60wgt3/wJ+2lFQN+k2ev0KLSRxiFdxpHtnWILZfHQw0=";

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];

    OPENSSL_NO_VENDOR = 1;
  };

  waybar = import ./waybar-settings.nix { inherit config; };
  waybarDotDir = ../../home/gars/dots/waybar;
in
{
  imports = [
    ./alacritty.nix
    ./fuzzel.nix
    ./mako.nix
  ];

  programs.waybar = {
    enable = true;
    style = waybar.style;
  };

  xdg.configFile."waybar/scripts/disks.sh" = {
    text = builtins.readFile "${waybarDotDir}/scripts/disks.sh";
    executable = true;
  };

  xdg.configFile."waybar/assets/quebec_emoji.txt".text =
    builtins.readFile "${waybarDotDir}/assets/quebec_emoji.txt";

  home.packages = with pkgs; [
    # ── Custom Builds ────────────────────────────────────────────────
    outside

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
    flameshot

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
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        asvetliakov.vscode-neovim
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
      ];
    })

    # ── Video Editor ────────────────────────────────────────────────
    kdePackages.kdenlive

    # ── Misc ────────────────────────────────────────────────────────
    anarchism

  ];

  # ── Brave with Symlinks + Extensions ──────────────────────────────
  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } # Google Translate
      { id = "bhlhnicpbhignbdhedgjhgdocnmhomnp"; } # ColorZilla
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
