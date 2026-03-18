# Niri Home Manager configuration.
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

  home.packages = with pkgs; [
    # Niri-specific
    grim # screenshot capture (used by niri's screenshot action)
  ];

  programs.waybar.settings = {
    mainBar =
      waybar.common
      // {
        "modules-left" = ["niri/workspaces" "niri/window"];

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
      config.lib.file.mkOutOfStoreSymlink (config.my.dotfilesRoot + "/dots/niri/config.kdl");
  };
}
