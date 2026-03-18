#
# ~/nixos-config/modules/shared/my-options.nix
#
# Shared repo-local option namespace used by both NixOS and Home Manager
# modules to avoid hardcoded user paths and host-specific service values.
#
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
