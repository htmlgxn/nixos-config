# Repo-local option namespace shared by NixOS and Home Manager modules.
{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.my = {
    primaryUser = mkOption {
      type = types.str;
      default = "";
      description = "Primary interactive user for this profile.";
    };

    repoRoot = mkOption {
      type = types.str;
      default = "";
      description = "Absolute path to the nixos-config checkout.";
    };

    dotfilesRoot = mkOption {
      type = types.str;
      default = "";
      description = "Absolute path to the repo-managed user dotfiles root.";
    };

    containersRoot = mkOption {
      type = types.str;
      default = "";
      description = "Absolute path to the repo-managed containers workspace.";
    };

    terminalTheme = mkOption {
      type = types.str;
      default = "gars-yellow-dark";
      description = "Terminal color theme name (gars-yellow-dark or gars-yellow-light).";
    };

    jellyfin = {
      dataDir = mkOption {
        type = types.str;
        default = "";
        description = "Persistent Jellyfin data directory.";
      };

      mediaRoots = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Directories Jellyfin needs ACL access to.";
      };

      transcodeSize = mkOption {
        type = types.str;
        default = "4G";
        description = "tmpfs size limit for Jellyfin transcodes.";
      };
    };
  };
}
