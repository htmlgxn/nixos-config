# Repo-local option namespace shared by NixOS and Home Manager modules.
{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.my = {
    primaryUser = mkOption {
      type = types.str;
      example = "gars";
      description = "Primary interactive user for this profile.";
    };

    repoRoot = mkOption {
      type = types.str;
      example = "/home/gars/nixos-config";
      description = "Absolute path to the nixos-config checkout.";
    };

    dotfilesRoot = mkOption {
      type = types.str;
      example = "/home/gars/nixos-config/home/gars";
      description = "Absolute path to the repo-managed user dotfiles root.";
    };

    containersRoot = mkOption {
      type = types.str;
      example = "/home/gars/nixos-config/containers";
      description = "Absolute path to the repo-managed containers workspace.";
    };

    terminalTheme = mkOption {
      type = types.str;
      default = "gars-yellow-dark";
      example = "gars-yellow-light";
      description = "Terminal color theme name (gars-yellow-dark or gars-yellow-light).";
    };

    guiTheme = mkOption {
      type = types.str;
      default = "gars-yellow-dark";
      example = "gars-yellow-light";
      description = "GUI theme name for waybar, sway, niri, mako, fuzzel, etc.";
    };

    cursorTheme = mkOption {
      type = types.str;
      default = "Catppuccin-Mocha-Yellow-Cursors";
      example = "Catppuccin-Latte-Blue-Cursors";
      description = "Cursor theme name for system and user environments.";
    };

    cursorSize = mkOption {
      type = types.int;
      default = 26;
      example = 24;
      description = "Cursor size in pixels.";
    };

    nvimTheme = mkOption {
      type = types.str;
      default = "gars-yellow-dark";
      example = "gars-yellow-light";
      description = "Neovim color theme name";
    };

    jellyfin = {
      dataDir = mkOption {
        type = types.str;
        example = "/var/lib/jellyfin";
        description = "Persistent Jellyfin data directory.";
      };

      mediaRoots = mkOption {
        type = types.listOf types.str;
        example = ["/mnt/media/movies" "/mnt/media/shows"];
        description = "Directories Jellyfin needs ACL access to.";
      };

      transcodeSize = mkOption {
        type = types.str;
        default = "4G";
        example = "8G";
        description = "tmpfs size limit for Jellyfin transcodes.";
      };
    };
  };
}
