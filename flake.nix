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
# 3. Add Home Manager configs below (see hmCLI_gars, hmGUI_Sway_gars, etc.):
#      hmCLI_<username> = mkHm "<username>" [];
#      hmGUI_Sway_<username> = mkHm "<username>" [ ./modules/home/gui-base.nix ... ];
#
# 4. Use in a NixOS configuration (see nixosConfigurations section):
#      my-host-tty = mkTTY_x86 "my-host" hmCLI_<username>;
#
# =============================================================================
# HOW TO ADD A NEW HOST
# =============================================================================
# 1. Create directory: hosts/<hostname>/
# 2. Create hosts/<hostname>/configuration.nix (copy from boreal or nixos-vm)
# 3. Add configuration below using helper functions:
#      <hostname>-tty = mkTTY_x86 "<hostname>" hmCLI_<user>;
#      <hostname>     = mkGUI_x86 "<hostname>" "sway" hmGUI_Sway_<user>;
#
# For aarch64 hosts (like cyberdeck), use mkTTY_aarch64 instead of mkTTY_x86
#
# =============================================================================
# HOW TO ADD A NEW GUI COMPOSITOR
# =============================================================================
# 1. Create system module: modules/system/<compositor>.nix
# 2. Create home-manager module: modules/home/<compositor>.nix
# 3. Add Home Manager config:
#      hmGUI_<Compositor>_<user> = mkHm "<user>" [
#        ./modules/home/gui-base.nix
#        ./modules/home/<compositor>.nix
#        ./modules/home/flatpak.nix
#      ];
# 4. Add NixOS config:
#      boreal-<compositor> = mkGUI_x86 "boreal" "<compositor>" hmGUI_<Compositor>_<user>;
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
    # ── Home Manager: Shared Imports (all users) ─────────────────────────
    # Common modules imported for every user (NOT user-specific)
    hmSharedImports = [
      ./modules/home/cli.nix
      # Language toolchains & custom packages
      ./modules/home/packages
    ];

    # ── Home Manager: Factory Function ───────────────────────────────────
    # Usage: mkHm "username" [ extra modules ]
    # Automatically includes ./modules/home/users/<username>.nix
    mkHm = username: extraImports: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs;};
      home-manager.users.${username} = {
        imports =
          hmSharedImports
          ++ [
            ./modules/home/users/${username}.nix
          ]
          ++ extraImports;
      };
    };

    # ── Home Manager: CLI Base (per-user) ────────────────────────────────
    # To add a user: copy these lines, replace "gars" with new username
    hmCLI_gars = mkHm "gars" [];

    hmCLIExtras_gars = mkHm "gars" [
      ./modules/home/cli-extras.nix
    ];

    hmCLI_Cyberdeck_gars = mkHm "gars" [
      ./modules/home/cli-cyberdeck.nix
    ];

    # ── Home Manager: GUI (per-user, extends CLI) ────────────────────────
    # To add a user: copy these lines, replace "gars" with new username
    hmGUI_Sway_gars = mkHm "gars" [
      ./modules/home/gui-base.nix
      ./modules/home/sway.nix
      ./modules/home/flatpak.nix
    ];

    hmGUI_Niri_gars = mkHm "gars" [
      ./modules/home/gui-base.nix
      ./modules/home/niri.nix
      ./modules/home/flatpak.nix
    ];

    hmGUI_Hyprland_gars = mkHm "gars" [
      ./modules/home/gui-base.nix
      ./modules/home/hyprland.nix
      ./modules/home/flatpak.nix
    ];

    # ── Home Manager: GUI + Gaming (per-user, extends CLI) ──────────────────
    hmGUI_Sway_Gaming_gars = mkHm "gars" [
      ./modules/home/gui-base.nix
      ./modules/home/sway.nix
      ./modules/home/flatpak.nix
      ./modules/home/gaming.nix
    ];

    hmGamescope_gars = mkHm "gars" [
      ./modules/home/gaming.nix
    ];

    # ── NixOS: Helper Functions (x86_64) ─────────────────────────────────
    # mkTTY_x86: Create a TTY-only configuration for x86_64 hosts
    # Usage: mkTTY_x86 "<hostname>" hmCLI_<username>
    # Note: Automatically includes hmCLIExtras_gars
    mkTTY_x86 = host: hmConfig:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/${host}/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/jellyfin.nix
          home-manager.nixosModules.home-manager
          hmConfig
          hmCLIExtras_gars
        ];
      };

    # mkGUI_x86: Create a GUI configuration for x86_64 hosts
    # Usage: mkGUI_x86 "<hostname>" "<compositor>" hmGUI_<Compositor>_<username> [ extra system modules ]
    # Available compositors: "sway", "niri", "hyprland"
    # Note: Automatically includes hmCLIExtras_gars
    mkGUI_x86 = host: compositor: hmConfig: extraSystemModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            ({...}: {
              nixpkgs.config.allowUnfree = true;
            })
            ./hosts/${host}/configuration.nix
            ./modules/system/cli.nix
            ./modules/system/${compositor}.nix
            ./modules/system/flatpak.nix
            ./modules/system/jellyfin.nix
          ]
          ++ extraSystemModules
          ++ [
            home-manager.nixosModules.home-manager
            hmConfig
            hmCLIExtras_gars
          ];
      };

    # ── NixOS: Helper Functions (aarch64) ────────────────────────────────
    # mkTTY_aarch64: Create a TTY-only configuration for aarch64 hosts
    # Usage: mkTTY_aarch64 "<hostname>" hmCLI_<username>
    mkTTY_aarch64 = host: hmConfig:
      nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/${host}/configuration.nix
          ./modules/system/cli.nix
          home-manager.nixosModules.home-manager
          hmConfig
        ];
      };

    # mkGamescope_x86: Create a minimal Steam + gamescope configuration
    # Usage: mkGamescope_x86 "<hostname>" hmGamescope_<username>
    # Note: Intentionally skips gui-base.nix and flatpak modules
    mkGamescope_x86 = host: hmConfig:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/${host}/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/gaming.nix
          ./modules/system/gamescope.nix
          home-manager.nixosModules.home-manager
          hmConfig
          hmCLIExtras_gars
        ];
      };
  in {
    nixosConfigurations = {
      # ── TTY Only (x86_64) ──────────────────────────────────────────────
      # Minimal TTY configuration - no GUI packages
      boreal-tty = mkTTY_x86 "boreal" hmCLI_gars;

      # TTY + cyberdeck-specific packages (test on boreal before deploying)
      # Add packages to modules/home/cli-cyberdeck.nix
      boreal-tty-cyberdeck = mkTTY_x86 "boreal" hmCLI_Cyberdeck_gars;

      # VM - minimal TTY configuration
      nixos-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/nixos-vm/configuration.nix
          ./modules/system/cli.nix
          home-manager.nixosModules.home-manager
          hmCLI_gars
          # hmCLIExtras_gars (disabled: VM minimal config)
        ];
      };

      # ── GUI (x86_64) ───────────────────────────────────────────────────
      # Production GUI configuration with Sway compositor
      boreal = mkGUI_x86 "boreal" "sway" hmGUI_Sway_gars [];

      # GUI with Sway + Gaming (Steam)
      boreal-gaming = mkGUI_x86 "boreal" "sway" hmGUI_Sway_Gaming_gars [
        ./modules/system/gaming.nix
      ];

      # Minimal Steam + gamescope session
      boreal-gamescope = mkGamescope_x86 "boreal" hmGamescope_gars;

      # GUI with Niri compositor (scrollable-tiling)
      boreal-niri = mkGUI_x86 "boreal" "niri" hmGUI_Niri_gars [];

      # GUI with Hyprland compositor
      boreal-hypr = mkGUI_x86 "boreal" "hyprland" hmGUI_Hyprland_gars [];

      # ── Future (aarch64) ───────────────────────────────────────────────
      # Uncomment and configure when cyberdeck hardware is acquired:
      # 1. Create modules/home/users/cyberdeck.nix (or use existing user)
      # 2. Create hmCLI_cyberdeck = mkHm "cyberdeck" [];
      # 3. Uncomment below:
      # cyberdeck = mkTTY_aarch64 "cyberdeck" hmCLI_cyberdeck;
    };
  };
}
