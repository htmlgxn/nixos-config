#
# ~/nixos-config/modules/home/fuzzel.nix
#
# Fuzzel configuration managed by Home Manager.
#
{...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Roboto Mono:size=13";
        prompt = "\"⚜️ \"";
        terminal = "alacritty";
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

      colors = {
        background = "262418ff";
        border = "826F11ff";
        text = "F6EEC9ff";
        prompt = "A29C7Fff";
        placeholder = "5B5742ff";
        input = "F6EEC9ff";

        match = "E3C220ff";
        selection = "3B3724ff";
        "selection-text" = "F6EEC9ff";
        "selection-match" = "EFDD84ff";
      };

      border = {
        width = 2;
        radius = 0;
      };
    };
  };
}
