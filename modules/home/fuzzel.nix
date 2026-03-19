#
# ~/nixos-config/modules/home/fuzzel.nix
#
# Fuzzel configuration managed by Home Manager.
# Colors are imported from shared gui-theme.nix.
#
{
  config,
  pkgs,
  ...
}: let
  emojiTools = import ./emoji-tools.nix {inherit pkgs;};
  theme = config.my.guiThemeData.fuzzel;
in {
  home.packages = [
    emojiTools.emojiPicker
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Roboto Mono:size=13";
        prompt = "\"⚜️ \"";
        terminal = "kitty";
        layer = "overlay";
        "exit-on-keyboard-focus-loss" = "yes";

        width = 48;
        lines = 16;
        "line-height" = 22;
        "letter-spacing" = 0;
        "horizontal-pad" = 26;
        "vertical-pad" = 12;
        "inner-pad" = 6;

        "image-size-ratio" = 0.5;
      };

      colors = theme.colors;

      border = {
        width = 2;
        radius = 0;
      };
    };
  };
}
