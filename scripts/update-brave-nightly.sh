#!/usr/bin/env bash
set -euo pipefail

# Overlay path: $OVERLAY if set (systemd timer), else the enclosing git checkout
# (`nix run .#update-brave-nightly`), else relative to this script.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "${SCRIPT_DIR}/..")"
OVERLAY="${OVERLAY:-${REPO_ROOT}/overlays/brave-nightly.nix}"

echo "==> Fetching latest Brave Nightly version..."
# Many nightly tags never get a Linux .deb (or get it hours later), so take the
# newest nightly that actually ships the amd64 .deb, not just the newest tag.
VERSION=$(curl -sf https://api.github.com/repos/brave/brave-browser/releases |
  jq -r '[.[]
    | select(.prerelease == true and .name != null and (.name | test("Nightly"; "i")))
    | (.tag_name | ltrimstr("v")) as $v
    | select(any(.assets[]; .name == "brave-browser-nightly_\($v)_amd64.deb"))
    | $v] | first // empty')

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
