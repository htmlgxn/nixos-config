# Hyprland Home Manager configuration.
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
    extraConfig = builtins.readFile (config.my.dotfilesRoot + "/dots/hypr/hyprland.conf");
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

  # Hyprland config is sourced from the repo file above.
}
