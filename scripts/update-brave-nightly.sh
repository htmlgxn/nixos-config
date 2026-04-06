#!/usr/bin/env bash
set -euo pipefail

# Resolve overlay path relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERLAY="${SCRIPT_DIR}/../overlays/brave-nightly.nix"

echo "==> Fetching latest Brave Nightly version..."
VERSION=$(curl -s https://api.github.com/repos/brave/brave-browser/releases |
  jq -r '[.[] | select(.prerelease == true) | select(.name != null) | select(.name | test("Nightly"; "i"))] | first | .tag_name | ltrimstr("v")')

if [[ -z $VERSION ]]; then
  echo "ERROR: Could not determine latest nightly version." >&2
  exit 1
fi

echo "==> Latest nightly: $VERSION"

URL="https://github.com/brave/brave-browser/releases/download/v${VERSION}/brave-browser-nightly_${VERSION}_amd64.deb"

echo "==> Prefetching hash..."
RAW_HASH=$(nix-prefetch-url --type sha256 "$URL" 2>/dev/null)
SRI=$(nix hash to-sri --type sha256 "$RAW_HASH")

echo "==> Hash: $SRI"

sed -i "s|version = \".*\";|version = \"${VERSION}\";|" "$OVERLAY"
sed -i "s|sha256 = \".*\";|sha256 = \"${SRI}\";|" "$OVERLAY"

echo "==> Updated $OVERLAY"
