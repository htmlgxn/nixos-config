#
# ~/nixos-config/modules/home/niri.nix
#
# Niri-specific home configuration.
# Imports gui-base.nix for shared packages, adds niri-specific dotfiles.
#

{ config, pkgs, ... }:

let
  waybar = import ./waybar-settings.nix { inherit pkgs; };
in

{
  imports = [
    ./gui-base.nix
  ];

  home.packages = with pkgs; [
    # Niri-specific
    grim # screenshot capture (used by niri's screenshot action)
  ];

  programs.waybar.settings = {
    mainBar = waybar.common // {
      "modules-left" = [ "niri/workspaces" "niri/window" ];

      "niri/workspaces" = {
        "disable-scroll" = true;
        "all-outputs" = true;
        format = "{name}";
      };

      "niri/window" = {
        "max-length" = 60;
        ellipsis = "...";
      };
    };
  };

  # ── Niri dotfile symlinks ───────────────────────────────────────────
  home.file = {
    ".config/niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/niri/config.kdl";
  };
}
