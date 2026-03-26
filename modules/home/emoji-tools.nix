{pkgs}: let
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
        | sort_by(.annotation // .name | ascii_downcase)
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
          --no-sort \
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

  emojiPickerCli = pkgs.writeShellApplication {
    name = "emoji-picker-cli";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.fzf
      pkgs.wl-clipboard
    ];
    text = ''
      set -euo pipefail

      no_copy=0
      while [ "$#" -gt 0 ]; do
        case "$1" in
          --no-copy|-n)
            no_copy=1
            shift
            ;;
          *)
            printf 'Unknown option: %s\n' "$1" >&2
            exit 2
            ;;
        esac
      done

      selection="$(
        fzf \
          --no-sort \
          --prompt='emoji> ' \
          --delimiter=$'\t' \
          --with-nth=1,2,3 \
          --height=40% \
          --layout=reverse \
          < "${emojiMenu}"
      )" || exit 0

      emoji="$(printf '%s\n' "$selection" | cut -f1)"
      if [ -z "$emoji" ]; then
        exit 0
      fi

      if [ "$no_copy" -eq 0 ] && [ "''${EMOJI_PICKER_NO_COPY-0}" != "1" ] && [ -n "''${WAYLAND_DISPLAY-}" ]; then
        wl-copy --trim-newline <<< "$emoji" || true
      fi

      printf '%s\n' "$emoji"
    '';
  };
in {
  inherit emojiPicker emojiPickerCli;
}
