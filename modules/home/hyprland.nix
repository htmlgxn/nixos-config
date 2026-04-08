# Hyprland Home Manager configuration.
{
  config,
  pkgs,
  ...
}: let
  waybar = import ./waybar-settings.nix {inherit pkgs config;};
in {
  imports = [
    ./gui-base-apps.nix
  ];

  programs.waybar.systemd = {
    enable = true;
    targets = ["hyprland-session.target"];
  };

  home.packages = with pkgs; [
    # Hyprland-specific
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      source = ${config.my.dotfilesRoot}/dots/hypr/hyprland.conf
    '';
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

  # Hyprland sources the repo-managed config file above at runtime.
}
