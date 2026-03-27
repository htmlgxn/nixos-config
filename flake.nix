# See docs/architecture.md and docs/workflows.md for repo structure and change workflows.
{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    jetpack-nixos = {
      url = "github:anduril/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bookokrat.url = "github:bugzmanov/bookokrat";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    nixos-hardware,
    jetpack-nixos,
    ...
  }: let
    lib = nixpkgs.lib;

    # ── Shared system modules (included in every NixOS profile) ──────
    sharedSystemModules = [
      ./modules/shared/options.nix
      ./modules/system/defaults.nix
    ];

    # ── Boreal-specific home module groups ──────────────────────────
    borealAiModules = [
      ./modules/home/ai-agents.nix
      ./modules/home/ollama-rocm.nix
    ];

    borealGuiModules =
      borealAiModules
      ++ [
        ./modules/home/brave-bookmarks-sync.nix
      ];

    borealDesktopModule = {pkgs, ...}: {
      my.dualKeyboardLayout = true;
      my.showRootDisk = true;
      my.terminal = "kitty";
      home.packages = [pkgs.kitty];
    };

    # ── Shared Home Manager modules (included in every profile) ──────
    sharedHomeModules = [
      ./modules/shared/options.nix
      ./modules/home/cli.nix
      ./modules/home/containers.nix
      ./modules/home/packages
    ];

    # ── User definitions ─────────────────────────────────────────────
    users = {
      gars = {
        module = ./modules/home/users/gars.nix;
        extraHomeModules = [
          ./modules/home/cli-extras.nix
        ];
      };
      htmlgxn = {
        module = ./modules/home/users/htmlgxn.nix;
        extraHomeModules = [];
      };
    };

    # ── NixOS host definitions ───────────────────────────────────────
    hosts = {
      boreal = {
        system = "x86_64-linux";
        module = ./hosts/boreal/configuration.nix;
        extraSystemModules = [
          ./modules/system/jellyfin.nix
          ./modules/system/containers.nix
        ];
        hostHomeModules = [./hosts/boreal/home.nix];
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
        extraSystemModules = [
          jetpack-nixos.nixosModules.default
        ];
        includeCliExtras = false;
      };

      rpi4 = {
        system = "aarch64-linux";
        module = ./hosts/rpi4/configuration.nix;
        extraSystemModules = [
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
        includeCliExtras = false;
      };
    };

    # ── Home Manager profiles ────────────────────────────────────────
    homeProfiles = {
      cli = [
        ./modules/home/nvim-theme.nix
      ];
      cli-cyberdeck = [
        ./modules/home/cli-cyberdeck.nix
        ./modules/home/nvim-theme.nix
      ];
      sway = [
        ./modules/home/gui-base.nix
        ./modules/home/gui-extras.nix
        ./modules/home/sway.nix
        ./modules/home/flatpak.nix
        ./modules/home/nvim-theme.nix
      ];
      sway-arm = [
        ./modules/home/gui-base.nix
        ./modules/home/sway.nix
        ./modules/home/nvim-theme.nix
      ];
      sway-arm-full = [
        ./modules/home/gui-base.nix
        ./modules/home/gui-extras.nix
        ./modules/home/sway.nix
        ./modules/home/nvim-theme.nix
      ];
      sway-gaming = [
        ./modules/home/gui-base.nix
        ./modules/home/gui-extras.nix
        ./modules/home/sway.nix
        ./modules/home/flatpak.nix
        ./modules/home/gaming.nix
        ./modules/home/nvim-theme.nix
      ];
      niri = [
        ./modules/home/gui-base.nix
        ./modules/home/gui-extras.nix
        ./modules/home/niri.nix
        ./modules/home/flatpak.nix
        ./modules/home/nvim-theme.nix
      ];
      hyprland = [
        ./modules/home/gui-base.nix
        ./modules/home/gui-extras.nix
        ./modules/home/hyprland.nix
        ./modules/home/flatpak.nix
        ./modules/home/nvim-theme.nix
      ];
      gamescope = [
        ./modules/home/gaming.nix
      ];
    };

    # ── NixOS system profiles ────────────────────────────────────────
    systemProfiles = {
      tty = [
        ./modules/system/cli.nix
      ];
      sway = [
        ./modules/system/cli.nix
        ./modules/system/sway.nix
        ./modules/system/flatpak.nix
      ];
      sway-arm = [
        ./modules/system/cli.nix
        ./modules/system/sway.nix
      ];
      sway-gaming = [
        ./modules/system/cli.nix
        ./modules/system/sway.nix
        ./modules/system/flatpak.nix
        ./modules/system/gaming.nix
      ];
      niri = [
        ./modules/system/cli.nix
        ./modules/system/niri.nix
        ./modules/system/flatpak.nix
      ];
      hyprland = [
        ./modules/system/cli.nix
        ./modules/system/hyprland.nix
        ./modules/system/flatpak.nix
      ];
      gamescope = [
        ./modules/system/cli.nix
        ./modules/system/gaming.nix
        ./modules/system/gamescope.nix
      ];
    };

    # ── Helper: assemble home imports list ────────────────────────────
    mkHomeImports = {
      userName,
      homeProfile,
      includeCliExtras ? false,
      hostHomeModules ? [],
      extraHomeModules ? [],
    }: let
      user = users.${userName};
    in
      sharedHomeModules
      ++ [user.module]
      ++ homeProfiles.${homeProfile}
      ++ lib.optionals includeCliExtras user.extraHomeModules
      ++ hostHomeModules
      ++ extraHomeModules;

    # ── Builder: NixOS Home Manager module ───────────────────────────
    mkHomeModule = {
      userName,
      homeProfile,
      includeCliExtras,
      hostHomeModules ? [],
      extraHomeModules ? [],
    }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs;};
      home-manager.users.${userName} = {
        imports = mkHomeImports {
          inherit userName homeProfile includeCliExtras hostHomeModules extraHomeModules;
        };
      };
    };

    # ── Builder: NixOS output ────────────────────────────────────────
    mkOutput = {
      hostName,
      userName,
      systemProfile,
      homeProfile,
      includeCliExtras,
      extraHomeModules ? [],
    }: let
      host = hosts.${hostName};
    in
      nixpkgs.lib.nixosSystem {
        modules =
          sharedSystemModules
          ++ [
            ({...}: {
              nixpkgs.hostPlatform = host.system;
              nixpkgs.config.allowUnfree = true;
            })
            host.module
          ]
          ++ systemProfiles.${systemProfile}
          ++ host.extraSystemModules
          ++ [
            home-manager.nixosModules.home-manager
            (mkHomeModule {
              inherit userName homeProfile includeCliExtras extraHomeModules;
              hostHomeModules = host.hostHomeModules or [];
            })
          ];
      };

    # ── Builder: nix-darwin output ───────────────────────────────────
    mkDarwinOutput = {
      userName,
      homeProfile,
      system,
      extraHomeModules ? [],
    }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/macbook/configuration.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.${userName} = {
              imports = mkHomeImports {
                inherit userName homeProfile extraHomeModules;
              };
            };
          }
        ];
      };

    # ── Builder: standalone Home Manager output ──────────────────────
    mkHomeOutput = {
      userName,
      homeProfile,
      system,
      extraHomeModules ? [],
    }: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules =
          mkHomeImports {
            inherit userName homeProfile extraHomeModules;
          }
          ++ [
            {
              home.username = userName;
              home.homeDirectory = "/home/${userName}";
              home.stateVersion = "25.11";
            }
          ];
      };

    # ── NixOS output definitions (grouped by host) ────────────────────
    borealOutputDefs = {
      boreal-tty = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli";
        extraHomeModules = borealAiModules;
        includeCliExtras = true;
      };

      boreal-tty-cyberdeck = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli-cyberdeck";
        extraHomeModules = borealAiModules;
        includeCliExtras = true;
      };

      boreal = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "sway";
        homeProfile = "sway";
        extraHomeModules = borealGuiModules ++ [borealDesktopModule];
        includeCliExtras = true;
      };

      boreal-gaming = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "sway-gaming";
        homeProfile = "sway-gaming";
        extraHomeModules = borealGuiModules ++ [borealDesktopModule];
        includeCliExtras = true;
      };

      boreal-gamescope = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "gamescope";
        homeProfile = "gamescope";
        extraHomeModules = [];
        includeCliExtras = false;
      };

      boreal-niri = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "niri";
        homeProfile = "niri";
        extraHomeModules = borealGuiModules;
        includeCliExtras = true;
      };

      boreal-hypr = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "hyprland";
        homeProfile = "hyprland";
        extraHomeModules = borealGuiModules;
        includeCliExtras = true;
      };
    };

    rpi4OutputDefs = {
      rpi4-tty = {
        hostName = "rpi4";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli";
        extraHomeModules = [];
        includeCliExtras = false;
      };

      rpi4-sway = {
        hostName = "rpi4";
        userName = "gars";
        systemProfile = "sway-arm";
        homeProfile = "sway-arm";
        extraHomeModules = [];
        includeCliExtras = false;
      };

      rpi4-sway-full = {
        hostName = "rpi4";
        userName = "gars";
        systemProfile = "sway-arm";
        homeProfile = "sway-arm-full";
        extraHomeModules = [];
        includeCliExtras = false;
      };

      rpi4-tty-cyberdeck = {
        hostName = "rpi4";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli-cyberdeck";
        extraHomeModules = [];
        includeCliExtras = false;
      };
    };

    otherOutputDefs = {
      nixos-vm = {
        hostName = "nixos-vm";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli";
        extraHomeModules = [];
        includeCliExtras = false;
      };

      cyberdeck-tty = {
        hostName = "cyberdeck";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli";
        extraHomeModules = [];
        includeCliExtras = false;
      };
    };

    nixosOutputDefs = borealOutputDefs // rpi4OutputDefs // otherOutputDefs;

    # ── nix-darwin output definitions ────────────────────────────────
    darwinOutputDefs = {
      macbook = {
        userName = "htmlgxn";
        homeProfile = "cli";
        system = "aarch64-darwin";
        extraHomeModules = [./modules/home/ai-agents.nix];
      };
    };

    # ── Standalone Home Manager output definitions ───────────────────
    homeOutputDefs = {
      fedora-arm = {
        userName = "htmlgxn";
        homeProfile = "cli";
        system = "aarch64-linux";
        extraHomeModules = [];
      };
    };
  in {
    nixosConfigurations = lib.mapAttrs (_: cfg: mkOutput cfg) nixosOutputDefs;
    darwinConfigurations = lib.mapAttrs (_: cfg: mkDarwinOutput cfg) darwinOutputDefs;
    homeConfigurations = lib.mapAttrs (_: cfg: mkHomeOutput cfg) homeOutputDefs;
  };
}
