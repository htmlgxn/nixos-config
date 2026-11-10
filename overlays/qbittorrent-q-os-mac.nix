#
# ~/nixos-config/overlays/qbittorrent-q-os-mac.nix
#
# Darwin-only: qtbase 6.12 marks Q_OS_MAC deprecated via `#pragma clang
# deprecated`, and qBittorrent 5.2.4 builds with -Werror, so the two remaining
# `#ifdef Q_OS_MAC` uses break the build. Q_OS_MACOS is the drop-in
# replacement. Drop this once nixpkgs ships a qBittorrent that no longer uses it.
#
_final: prev:
prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  qbittorrent = prev.qbittorrent.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        sed -i 's/\bQ_OS_MAC\b/Q_OS_MACOS/g' \
          src/gui/log/loglistview.cpp src/gui/optionsdialog.cpp
      '';
  });
}
