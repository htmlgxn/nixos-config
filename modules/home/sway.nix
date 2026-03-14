#
# ~/nixos-config/modules/home/sway.nix
#
# Sway-specific home configuration.
# Imports gui-base.nix for shared packages, adds sway-specific dotfiles.
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
  };
}
