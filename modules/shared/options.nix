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

    borealHost = mkOption {
      type = types.str;
      default = "boreal.local";
      description = "Hostname used to reach boreal. Set to \"localhost\" on boreal itself.";
    };

    ollamaPackage = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Ollama package variant to install (ollama-rocm, ollama, or null to skip).";
    };

    terminal = mkOption {
      type = types.str;
      default = "foot";
      description = "Terminal emulator command used by the compositor.";
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

    dotfilesNixPath = mkOption {
      type = types.path;
      description = "Nix path to the repo-managed user dotfiles root (for store copies).";
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

    borg = {
      repoPath = mkOption {
        type = types.str;
        default = "";
        example = "/mnt/archive/backup/gars";
        description = "Absolute path to the borg repository.";
      };

      paths = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["/home/gars/dev" "/home/gars/documents"];
        description = "Directories to back up.";
      };

      exclude = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["*/node_modules" "*/.direnv"];
        description = "Glob patterns to exclude from backup.";
      };

      startAt = mkOption {
        type = types.str;
        default = "daily";
        example = "03:00";
        description = "systemd calendar expression for backup schedule.";
      };

      keep = {
        daily = mkOption { type = types.int; default = 14; };
        weekly = mkOption { type = types.int; default = 8; };
        monthly = mkOption { type = types.int; default = 12; };
        yearly = mkOption { type = types.int; default = 5; };
      };
    };

    jellyfin = {
      vaDriver = mkOption {
        type = types.str;
        default = "";
        description = "VAAPI driver name (e.g. radeonsi). Empty string skips override.";
      };

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
