#
# ~/nixos-config/flake.nix
#
# =============================================================================
# CONFIGURATION HIERARCHY
# =============================================================================
#   TTY  → cli.nix + cli-extras.nix (+ optional cli-*.nix)
#   GUI  → TTY + gui-base.nix + <compositor>.nix + flatpak.nix
#   GAME → TTY + gaming.nix + gamescope.nix
#
# =============================================================================
# NIXOS CONFIGURATIONS
# =============================================================================
#   boreal-tty         - TTY-only on boreal hardware
#   boreal-tty-cyberdeck - TTY + cyberdeck packages (testing on boreal)
#   boreal             - GUI (Sway) - production
#   boreal-gaming      - GUI (Sway) + Steam for gaming
#   boreal-gamescope   - Minimal Steam + gamescope session
#   boreal-niri        - GUI (Niri)
#   boreal-hypr        - GUI (Hyprland)
#   nixos-vm           - TTY-only VM
#   cyberdeck          - (future) TTY-only on aarch64 hardware
#
# =============================================================================
# HOW TO ADD A NEW USER
# =============================================================================
# 1. Create system user in hosts/<host>/configuration.nix:
#      users.users.<username> = {
#        isNormalUser = true;
#        extraGroups = [ "wheel" "networkmanager" ];
#        initialPassword = "changeme";
#      };
#
# 2. Create user home-manager module:
#      modules/home/users/<username>.nix
#    (copy from gars.nix, adjust username/homeDirectory/shellAliases)
#
# 3. Register the user in the `users` attrset below:
#      <username> = {
#        module = ./modules/home/users/<username>.nix;
#        extraHomeModules = [ ./modules/home/cli-extras.nix ];
#      };
#
# 4. Reference that user from an entry in `outputDefs`.
#
# =============================================================================
# HOW TO ADD A NEW HOST
# =============================================================================
# 1. Create directory: hosts/<hostname>/
# 2. Create hosts/<hostname>/configuration.nix (copy from boreal or nixos-vm)
# 3. Register the host in the `hosts` attrset below:
#      <hostname> = {
#        system = "x86_64-linux";
#        module = ./hosts/<hostname>/configuration.nix;
#        extraSystemModules = [ ];
#        includeCliExtras = true;
#      };
# 4. Add entries in `outputDefs` for the profiles you want to expose.
#
# =============================================================================
# HOW TO ADD A NEW GUI COMPOSITOR
# =============================================================================
# 1. Create system module: modules/system/<compositor>.nix
# 2. Create home-manager module: modules/home/<compositor>.nix
# 3. Add entries in `homeProfiles` and `systemProfiles` below.
# 4. Point an `outputDefs` entry at those profile names.
#
# =============================================================================
# HOW TO ADD PACKAGES
# =============================================================================
# - CLI packages (all users):     modules/home/cli.nix
# - CLI packages (per-user):      modules/home/cli-extras.nix (or create new)
# - CLI packages (per-device):    modules/home/cli-cyberdeck.nix
# - GUI packages (all users):     modules/home/gui-base.nix
# - System packages:              modules/system/cli.nix or hosts/<host>/configuration.nix
#
# =============================================================================
{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bookokrat.url = "github:bugzmanov/bookokrat";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    lib = nixpkgs.lib;

    sharedHomeModules = [
      ./modules/shared/my-options.nix
      ./modules/home/cli.nix
      ./modules/home/packages
    ];

    users = {
      gars = {
        module = ./modules/home/users/gars.nix;
        extraHomeModules = [
          ./modules/home/cli-extras.nix
        ];
      };
    };

    hosts = {
      boreal = {
        system = "x86_64-linux";
        module = ./hosts/boreal/configuration.nix;
        extraSystemModules = [
          ./modules/system/jellyfin.nix
        ];
        includeCliExtras = true;
      };

      nixos-vm = {
        system = "x86_64-linux";
        module = ./hosts/nixos-vm/configuration.nix;
        extraSystemModules = [];
        includeCliExtras = false;
      };

      cyberdeck = {
        system = "aarch64-linux";
        module = ./hosts/cyberdeck/configuration.nix;
        extraSystemModules = [];
        includeCliExtras = false;
      };
    };

    homeProfiles = {
      cli = [];
      cli-cyberdeck = [
        ./modules/home/cli-cyberdeck.nix
      ];
      sway = [
        ./modules/home/gui-base.nix
        ./modules/home/sway.nix
        ./modules/home/flatpak.nix
      ];
      sway-gaming = [
        ./modules/home/gui-base.nix
        ./modules/home/sway.nix
        ./modules/home/flatpak.nix
        ./modules/home/gaming.nix
      ];
      niri = [
        ./modules/home/gui-base.nix
        ./modules/home/niri.nix
        ./modules/home/flatpak.nix
      ];
      hyprland = [
        ./modules/home/gui-base.nix
        ./modules/home/hyprland.nix
        ./modules/home/flatpak.nix
      ];
      gamescope = [
        ./modules/home/gaming.nix
      ];
    };

    systemProfiles = {
      tty = [
        ./modules/shared/my-options.nix
        ./modules/system/cli.nix
      ];
      sway = [
        ./modules/shared/my-options.nix
        ./modules/system/cli.nix
        ./modules/system/sway.nix
        ./modules/system/flatpak.nix
      ];
      sway-gaming = [
        ./modules/shared/my-options.nix
        ./modules/system/cli.nix
        ./modules/system/sway.nix
        ./modules/system/flatpak.nix
        ./modules/system/gaming.nix
      ];
      niri = [
        ./modules/shared/my-options.nix
        ./modules/system/cli.nix
        ./modules/system/niri.nix
        ./modules/system/flatpak.nix
      ];
      hyprland = [
        ./modules/shared/my-options.nix
        ./modules/system/cli.nix
        ./modules/system/hyprland.nix
        ./modules/system/flatpak.nix
      ];
      gamescope = [
        ./modules/shared/my-options.nix
        ./modules/system/cli.nix
        ./modules/system/gaming.nix
        ./modules/system/gamescope.nix
      ];
    };

    mkHomeModule = {
      userName,
      homeProfile,
      includeCliExtras,
    }: let
      user = users.${userName};
    in {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs;};
      home-manager.users.${userName} = {
        imports =
          sharedHomeModules
          ++ [user.module]
          ++ homeProfiles.${homeProfile}
          ++ lib.optionals includeCliExtras user.extraHomeModules;
      };
    };

    mkOutput = {
      hostName,
      userName,
      systemProfile,
      homeProfile,
      includeCliExtras ? hosts.${hostName}.includeCliExtras,
    }: let
      host = hosts.${hostName};
    in
      nixpkgs.lib.nixosSystem {
        system = host.system;
        modules =
          [
            ({...}: {
              nixpkgs.config.allowUnfree = true;
            })
            host.module
          ]
          ++ systemProfiles.${systemProfile}
          ++ host.extraSystemModules
          ++ [
            home-manager.nixosModules.home-manager
            (mkHomeModule {
              inherit userName homeProfile includeCliExtras;
            })
          ];
      };

    outputDefs = {
      boreal-tty = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli";
      };

      boreal-tty-cyberdeck = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli-cyberdeck";
      };

      nixos-vm = {
        hostName = "nixos-vm";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli";
        includeCliExtras = false;
      };

      boreal = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "sway";
        homeProfile = "sway";
      };

      boreal-gaming = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "sway-gaming";
        homeProfile = "sway-gaming";
      };

      boreal-gamescope = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "gamescope";
        homeProfile = "gamescope";
      };

      boreal-niri = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "niri";
        homeProfile = "niri";
      };

      boreal-hypr = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "hyprland";
        homeProfile = "hyprland";
      };
    };
  in {
    nixosConfigurations = lib.mapAttrs (_: cfg: mkOutput cfg) outputDefs;
  };
}
