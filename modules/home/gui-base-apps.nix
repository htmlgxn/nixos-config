# Cross-platform GUI applications included in all gui/sway profiles.
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.packages = with pkgs;
    [
      # ── Media ──────────────────────────────────────────────────────
      (mpv.override { youtubeSupport = false; })

      # ── Messaging ──────────────────────────────────────────────────
      ayugram-desktop
      vesktop

      # ── Browser ────────────────────────────────────────────────────
      librewolf

      # ── Documents & Notes ───────────────────────────────────────────
      obsidian
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      signal-desktop
      calibre-no-speech
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

  # ── Spicetify (Spotify with theming) ────────────────────────────
  # Spotify is only available on x86_64-linux, x86_64-darwin, and aarch64-darwin.
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    supported = builtins.elem pkgs.stdenv.hostPlatform.system ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];
  in
    lib.mkIf supported {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        shuffle
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
}
