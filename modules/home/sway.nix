#
# ~/nixos-config/modules/home/sway.nix
#
# Sway-specific home configuration.
# Imports gui-base.nix for shared packages, adds sway-specific dotfiles.
#

{ config, pkgs, ... }:

let
  waybar = import ./waybar-settings.nix { inherit config; };
in

{
  imports = [
    ./gui-base.nix
  ];

  home.packages = with pkgs; [
    # Sway-specific
    sway-contrib.grimshot
  ];

  programs.waybar.settings = {
    mainBar = waybar.common // {
      "modules-left" = [ "sway/workspaces" "sway/window" "sway/mode" ];

      "sway/workspaces" = {
        "disable-scroll" = true;
        "all-outputs" = true;
        format = "{name}";
      };

      "sway/window" = {
        "max-length" = 60;
        ellipsis = "...";
      };

      "sway/mode" = {
        format = "{}";
      };
    };
  };

  # ── Compositor-specific dotfile symlinks ───────────────────────────
  home.file = {
    ".config/sway/config".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/sway/config";
  };
}
