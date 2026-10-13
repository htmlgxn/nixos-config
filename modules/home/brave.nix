# Brave with the shared extension set. The package is pkgs.brave, so each
# output's overlays decide the build (nightly on boreal, stable elsewhere).
#
# On macOS the extensions are installed system-wide by nix-darwin instead
# (hosts/macbook/configuration.nix): ~/Library/Application Support/BraveSoftware
# is TCC-protected app data, and writing there fails whenever kitty's ad-hoc
# signature changes and its Full Disk Access grant silently stops applying.
{
  lib,
  pkgs,
  ...
}: {
  programs.brave = {
    enable = true;
    extensions = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
      map (id: {inherit id;}) (import ../shared/brave-extensions.nix)
    );
  };
}
