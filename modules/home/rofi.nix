#
# ~/nixos-config/modules/home/rofi.nix
#
# Rofi configuration managed by Home Manager.
# Colors mirror fuzzel exactly (pulled from config.my.guiThemeData.fuzzel).
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  fuzz = config.my.guiThemeData.fuzzel.colors;
  # Fuzzel colors are 8-char RRGGBBAA — strip alpha suffix and prepend #
  hex = s: "#${lib.substring 0 6 s}";

  theme = pkgs.writeText "rofi-theme.rasi" ''
    * {
        background-color: ${hex fuzz.background};
        border-color:     ${hex fuzz.border};
        text-color:       ${hex fuzz.text};
        spacing:          0;
    }

    window {
        width:            640px;
        border:           2px;
        border-color:     ${hex fuzz.border};
        background-color: ${hex fuzz.background};
    }

    mainbox {
        padding: 10px 14px;
    }

    message {
        border:   0px;
        padding:  6px;
    }

    listview {
        lines:   16;
        border:  0px;
        padding: 4px 0px;
    }

    element {
        padding: 4px 8px;
        border:  0px;
    }

    element.normal.normal {
        background-color: ${hex fuzz.background};
        text-color:       ${hex fuzz.text};
    }

    element.normal.active {
        background-color: ${hex fuzz.background};
        text-color:       ${hex fuzz.prompt};
    }

    element.normal.urgent {
        background-color: ${hex fuzz.background};
        text-color:       ${hex fuzz.text};
    }

    element.selected.normal {
        background-color: ${hex fuzz.selection};
        text-color:       ${hex fuzz.selection-text};
    }

    element.selected.active {
        background-color: ${hex fuzz.selection};
        text-color:       ${hex fuzz.selection-text};
    }

    element.selected.urgent {
        background-color: ${hex fuzz.selection};
        text-color:       ${hex fuzz.selection-text};
    }

    element-text {
        background-color: transparent;
        text-color:       inherit;
        highlight:        bold ${hex fuzz.match};
    }

    element-icon {
        background-color: transparent;
        size:             1.5em;
    }

    prompt {
        text-color: ${hex fuzz.prompt};
        padding:    0px 6px 0px 0px;
    }

    entry {
        text-color: ${hex fuzz.text};
    }

    inputbar {
        padding:  6px;
        children: [prompt, entry];
    }
  '';
in {
  programs.rofi = {
    enable = true;
    terminal = config.my.terminal;
    font = "Roboto Mono 13";
    theme = theme;
  };
}
