#
# ~/nixos-config/modules/home/niri.nix
#
# Niri-specific home configuration.
# Imports gui-base.nix for shared packages, adds niri-specific dotfiles.
#

{ config, pkgs, ... }:

{
  imports = [
    ./gui-base.nix
  ];

  # ── Niri dotfile symlinks ───────────────────────────────────────────
  home.file = {
    ".config/niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/niri/config.kdl";
  };
}
