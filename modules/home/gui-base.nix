# Shared desktop packages for GUI profiles.
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # ── Launcher ────────────────────────────────────────────────────
    fuzzel

    # ── File Manager ────────────────────────────────────────────────
    thunar

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

    # ── Image Viewer ────────────────────────────────────────────────
    swayimg

    # ── System Utilities ────────────────────────────────────────────
    polkit_gnome
    brightnessctl
    networkmanagerapplet
    pavucontrol

    # ── Messaging ────────────────────────────────────────────
    signal-desktop
    telegram-desktop

    # ── alt-browser ────────────────────────────────────────────
    librewolf
  ];

  # ── Brave with Extensions ───────────────────────────────────────
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
}
