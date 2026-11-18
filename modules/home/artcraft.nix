# ArtCraft apps (https://getartcraft.com, github.com/storytold): native Rust
# creative/office suite. Imported by gui-base-apps.nix and jtop's
# janine-home.nix, so every graphical output gets the same set.
#
# Only the apps packaged in nixpkgs are listed. Not packaged yet: FilmCraft,
# EffectCraft, AniCraft, DesignCraft, FigCraft, TextureCraft, MaterialCraft,
# Craft Anything, and the ArtCraft launcher/Studio.
{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      # ── Image & design ───────────────────────────────────────────
      photocraft # layered image editor (PSD/PSB)
      vectorcraft # vector illustration (SVG/PDF)
      lightcraft # photo library and raw developer
      cadcraft # 2D drafting (DXF/DWG)

      # ── Office ───────────────────────────────────────────────────
      pdfcraft # PDF workbench
      wordcraft # word processor (DOCX/ODT/RTF)
      deckcraft # presentations (PPTX)
      gridcraft # spreadsheets (XLSX/CSV/TSV)
    ]
    # The nixpkgs package claims darwin but depends on alsa-lib unconditionally.
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      soundcraft # digital audio workstation
    ];
}
