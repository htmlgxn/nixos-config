# Clipdoc - Copy text files to Wayland clipboard
{pkgs}: let
  clipdoc = pkgs.writeShellApplication {
    name = "clipdoc";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.wl-clipboard
      pkgs.file
    ];
    text = ''
      set -euo pipefail

      if [ "$#" -ne 1 ]; then
        echo "Usage: clipdoc <file>" >&2
        echo "Copy text file contents to the Wayland clipboard." >&2
        exit 1
      fi

      file="$1"

      if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist or is not a regular file." >&2
        exit 1
      fi

      # Check if file is binary
      if file --mime-type "$file" | grep -q "text/"; then
        wl-copy --trim-newline < "$file"
        echo "Copied '$file' to clipboard."
      else
        echo "Error: File '$file' does not appear to be a text file." >&2
        exit 1
      fi
    '';
  };
in {
  inherit clipdoc;
}
