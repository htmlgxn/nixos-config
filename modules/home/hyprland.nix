#
# ~/nixos-config/modules/home/hyprland.nix
#
# Hyprland-specific home configuration.
# Imports gui-base.nix for shared packages, adds hyprland-specific dotfiles.
#
{
  config,
  pkgs,
  ...
}: let
  waybar = import ./waybar-settings.nix {inherit pkgs;};
in {
  imports = [
    ./gui-base.nix
  ];

  programs.waybar.systemd = {
    enable = true;
    target = "hyprland-session.target";
  };

  home.packages = with pkgs; [
    # Hyprland-specific
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
  };

  programs.waybar.settings = {
    mainBar =
      waybar.common
      // {
        "modules-left" = ["hyprland/workspaces" "hyprland/window"];

        "hyprland/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
          format = "{name}";
        };

        "hyprland/window" = {
          "max-length" = 60;
          ellipsis = "...";
        };
      };
  };

  # ── Hyprland dotfile symlink ─────────────────────────────────────
  home.file = {
    ".config/hypr/hyprland.conf".source =
      config.lib.file.mkOutOfStoreSymlink "/home/gars/nixos-config/home/gars/dots/hypr/hyprland.conf";
  };
}
