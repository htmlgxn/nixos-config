#
# ~/nixos-config/modules/home/gui.nix
#
# Sway-specific home configuration.
# Imports gui-base.nix for shared packages, adds compositor-specific dotfiles.
#

{ config, pkgs, ... }:

{
  imports = [
    ./gui-base.nix
  ];

  home.packages = with pkgs; [
    # Sway-specific
    sway-contrib.grimshot
  ];

  # ── Compositor-specific dotfile symlinks ───────────────────────────
  home.file = {
    ".config/sway/config".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/sway/config";
    ".config/niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/niri/config.kdl";
  };
}
