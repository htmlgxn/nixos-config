#
# ~/nixos-config/modules/home/xterm.nix
#
# XTerm themed to match kitty/gars-yellow-dark as closely as possible.
# Colors pulled from config.my.terminalThemeData (same source as kitty.nix).
#
{
  config,
  pkgs,
  ...
}: let
  c = config.my.terminalThemeData.colors;
in {
  home.packages = [pkgs.xterm];

  xresources.properties = {
    # ── Identity ──────────────────────────────────────────────────────
    "XTerm.termName" = "xterm-256color";

    # ── Font ──────────────────────────────────────────────────────────
    "XTerm.vt100.faceName" = "Roboto Mono:size=${toString config.my.terminalFontSize}";
    "XTerm.vt100.faceSize" = config.my.terminalFontSize;

    # ── Colors ────────────────────────────────────────────────────────
    "XTerm.vt100.background" = c.background;
    "XTerm.vt100.foreground" = c.foreground;
    "XTerm.vt100.cursorColor" = c.cursor;
    "XTerm.vt100.colorBD" = c.brightForeground;

    # Normal palette (0-7)
    "XTerm.vt100.color0" = c.normal.black;
    "XTerm.vt100.color1" = c.normal.red;
    "XTerm.vt100.color2" = c.normal.green;
    "XTerm.vt100.color3" = c.normal.yellow;
    "XTerm.vt100.color4" = c.normal.blue;
    "XTerm.vt100.color5" = c.normal.magenta;
    "XTerm.vt100.color6" = c.normal.cyan;
    "XTerm.vt100.color7" = c.normal.white;

    # Bright palette (8-15)
    "XTerm.vt100.color8" = c.bright.black;
    "XTerm.vt100.color9" = c.bright.red;
    "XTerm.vt100.color10" = c.bright.green;
    "XTerm.vt100.color11" = c.bright.yellow;
    "XTerm.vt100.color12" = c.bright.blue;
    "XTerm.vt100.color13" = c.bright.magenta;
    "XTerm.vt100.color14" = c.bright.cyan;
    "XTerm.vt100.color15" = c.bright.white;

    # ── Appearance ────────────────────────────────────────────────────
    "XTerm.vt100.scrollBar" = false;
    "XTerm.vt100.scrollTtyOutput" = false;
    "XTerm.vt100.saveLines" = 10000;
    "XTerm.vt100.internalBorder" = 8;
    "XTerm.vt100.borderWidth" = 0;

    # Use bright colors for bold (matches kitty behavior)
    "XTerm.vt100.boldMode" = false;
    "XTerm.vt100.colorBDMode" = true;

    # ── Selection ─────────────────────────────────────────────────────
    "XTerm.vt100.highlightSelection" = true;
    "XTerm.vt100.highlightColor" = c.selectionBackground;
    "XTerm.vt100.highlightTextColor" = c.selectionText;

    # ── Geometry ──────────────────────────────────────────────────────
    "XTerm.vt100.geometry" = "130x40";
  };
}
