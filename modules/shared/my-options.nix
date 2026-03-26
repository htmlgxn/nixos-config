# Repo-local option namespace shared by NixOS and Home Manager modules.
{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.my = {
    isNixOS = mkOption {
      type = types.bool;
      default = true;
      description = "Whether the host is a NixOS system (false for standalone HM or nix-darwin).";
    };

    ollamaPackage = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Ollama package variant to install (ollama-rocm, ollama, or null to skip).";
    };

    dualKeyboardLayout = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dual us/graphite keyboard layout with Alt+Shift_L to switch.";
    };

    showRootDisk = mkOption {
      type = types.bool;
      default = false;
      description = "Show root disk usage % in waybar.";
    };

    wallpaper = mkOption {
      type = types.path;
      description = "Absolute path to the wallpaper image used by swaybg.";
    };

    networkInterface = mkOption {
      type = types.str;
      default = "enp6s0";
      example = "wlan0";
      description = "Primary network interface name shown in waybar.";
    };

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

    nvimTheme = mkOption {
      type = types.str;
      default = "gars-yellow-dark";
      example = "gars-yellow-light";
      description = "Neovim color theme name";
    };

    jellyfin = {
      dataDir = mkOption {
        type = types.str;
        default = "";
        example = "/var/lib/jellyfin";
        description = "Persistent Jellyfin data directory.";
      };

      mediaRoots = mkOption {
        type = types.listOf types.str;
        default = [];
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
