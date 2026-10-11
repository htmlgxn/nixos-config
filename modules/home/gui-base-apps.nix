# Cross-platform GUI applications included in all gui/sway profiles.
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./brave.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs;
    [
      # ── Media ──────────────────────────────────────────────────────
      (mpv.override {youtubeSupport = false;})
      qbittorrent

      # ── Social ─────────────────────────────────────────────────────
      #ayugram-desktop
      vesktop

      # ── Browser ────────────────────────────────────────────────────
      librewolf

      # ── Documents & Notes ──────────────────────────────────────────
      obsidian
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      signal-desktop
      calibre-no-speech
    ];
}
