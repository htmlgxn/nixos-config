#
# ~/nixos-config/modules/home/fuzzel.nix
#
# Fuzzel configuration managed by Home Manager.
#
{pkgs, ...}: let
  openmojiSrc = pkgs.fetchFromGitHub {
    owner = "hfg-gmuend";
    repo = "openmoji";
    rev = pkgs.openmoji-color.version;
    hash = "sha256-4dYtLaABu88z25Ud/cuOECajxSJWR01qcTIZNWN7Fhw=";
  };

  emojiMenu =
    pkgs.runCommandLocal "openmoji-fuzzel-menu.tsv" {
      nativeBuildInputs = [pkgs.jq];
    } ''
      set -euo pipefail

      json_path=""
      for candidate in \
        "${openmojiSrc}/data/openmoji.json" \
        "${openmojiSrc}/openmoji.json"; do
        if [ -f "$candidate" ]; then
          json_path="$candidate"
          break
        fi
      done

      if [ -z "$json_path" ]; then
        echo "Unable to locate OpenMoji metadata JSON in ${openmojiSrc}" >&2
        exit 1
      fi

      jq -r '
        def rows:
          if type == "array" then .
          elif type == "object" then to_entries | map(.value)
          else []
          end;

        rows
        | map(select((.emoji? // "") != "" and ((.annotation? // .name? // "") != "")))
        | unique_by(.emoji)
        | .[]
        | [
            .emoji,
            (.annotation // .name),
            (
              [
                .group?,
                .subgroups?,
                (.tags? // []),
                (.keywords? // []),
                (.aliases? // [])
              ]
              | flatten
              | map(select(. != null and . != ""))
              | unique
              | join(", ")
            )
          ]
        | @tsv
      ' "$json_path" > "$out"
    '';

  emojiPicker = pkgs.writeShellApplication {
    name = "emoji-picker";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.fuzzel
      pkgs.wl-clipboard
      pkgs.wtype
    ];
    text = ''
      set -euo pipefail

      selection="$(
        fuzzel --dmenu \
          --prompt='emoji> ' \
          --font='Roboto Mono,OpenMoji Color:size=13' \
          < "${emojiMenu}"
      )" || exit 0

      emoji="$(printf '%s\n' "$selection" | cut -f1)"
      if [ -z "$emoji" ]; then
        exit 0
      fi

      printf '%s' "$emoji" | wl-copy --trim-newline

      if [ -n "''${SWAYSOCK-}" ] && [ "''${EMOJI_PICKER_NO_TYPE-0}" != "1" ]; then
        wtype "$emoji" || true
      fi
    '';
  };
in {
  home.packages = [
    emojiPicker
  ];

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
