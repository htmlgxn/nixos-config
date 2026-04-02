#
# ~/nixos-config/modules/home/rofi.nix
#
# Rofi configuration managed by Home Manager.
# Colors mirror fuzzel exactly (pulled from config.my.guiThemeData.fuzzel).
#
{
  config,
  lib,
  ...
}: let
  fuzz = config.my.guiThemeData.fuzzel.colors;
  # Fuzzel colors are 8-char RRGGBBAA — strip alpha suffix and prepend #
  inherit (config.lib.formats.rasi) mkLiteral;
  hex = s: mkLiteral "#${lib.substring 0 6 s}";
in {
  programs.rofi = {
    enable = true;
    terminal = config.my.terminal;
    font = "Roboto Mono 13";
    theme = {
      "*" = {
        background-color = hex fuzz.background;
        border-color = hex fuzz.border;
        text-color = hex fuzz.text;
        spacing = 0;
      };

      window = {
        width = mkLiteral "640px";
        border = 2;
        border-color = hex fuzz.border;
        background-color = hex fuzz.background;
      };

      mainbox = {
        padding = mkLiteral "10px 14px";
      };

      message = {
        border = 0;
        padding = 6;
      };

      listview = {
        lines = 16;
        border = 0;
        padding = mkLiteral "4px 0px";
      };

      element = {
        padding = mkLiteral "4px 8px";
        border = 0;
      };

      "element normal normal" = {
        background-color = hex fuzz.background;
        text-color = hex fuzz.text;
      };

      "element normal active" = {
        background-color = hex fuzz.background;
        text-color = hex fuzz.prompt;
      };

      "element normal urgent" = {
        background-color = hex fuzz.background;
        text-color = hex fuzz.text;
      };

      "element selected normal" = {
        background-color = hex fuzz.selection;
        text-color = hex fuzz."selection-text";
      };

      "element selected active" = {
        background-color = hex fuzz.selection;
        text-color = hex fuzz."selection-text";
      };

      "element selected urgent" = {
        background-color = hex fuzz.selection;
        text-color = hex fuzz."selection-text";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        highlight = mkLiteral "bold #${lib.substring 0 6 fuzz.match}";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        size = mkLiteral "1.5em";
      };

      prompt = {
        text-color = hex fuzz.prompt;
        padding = mkLiteral "0px 6px 0px 0px";
      };

      entry = {
        text-color = hex fuzz.text;
      };

      inputbar = {
        padding = 6;
        children = mkLiteral "[prompt, entry]";
      };
    };
  };
}
