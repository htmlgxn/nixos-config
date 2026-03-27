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

    # ── Named home overlay groups (selected explicitly by outputs) ──
    borealDesktopModule = {pkgs, ...}: {
      my.dualKeyboardLayout = true;
      my.showRootDisk = true;
      my.terminal = "kitty";
      home.packages = [pkgs.kitty];
    };

    homeOverlayGroups = rec {
      ai-cli-orchestrators = [
        ./modules/home/ai-cli-orchestrators.nix
      ];

      ai-cli-extras = [
        ./modules/home/ai-cli-extras.nix
      ];

      ai-cli-agents = [
        ./modules/home/ai-cli-agents.nix
      ];

      ai-cli-opencode = [
        ./modules/home/ai-cli-opencode.nix
      ];

      ai-cli-all =
        ai-cli-orchestrators
        ++ ai-cli-agents
        ++ ai-cli-opencode
        ++ ai-cli-extras;

      ai-ollama = [
        ./modules/home/ai-ollama.nix
      ];

      ai-ollama-rocm =
        ai-ollama
        ++ [
          ./modules/home/ai-ollama-rocm.nix
        ];

      cli-extras = [
        ./modules/home/cli-extras.nix
      ];

      boreal-gui =
        ai-cli-all
        ++ ai-ollama-rocm
        ++ [
          ./modules/home/brave-bookmarks-sync.nix
        ];

      boreal-desktop = [
        borealDesktopModule
      ];
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
      };
      htmlgxn = {
        module = ./modules/home/users/htmlgxn.nix;
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
      };

      nixos-vm = {
        system = "x86_64-linux";
        module = ./hosts/nixos-vm/configuration.nix;
        extraSystemModules = [];
      };

      cyberdeck = {
        system = "aarch64-linux";
        module = ./hosts/cyberdeck/configuration.nix;
        extraSystemModules = [
          jetpack-nixos.nixosModules.default
        ];
      };

      rpi4 = {
        system = "aarch64-linux";
        module = ./hosts/rpi4/configuration.nix;
        extraSystemModules = [
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
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
    resolveHomeOverlays = overlayNames:
      builtins.concatLists (map (name: homeOverlayGroups.${name}) overlayNames);

    mkHomeImports = {
      userName,
      homeProfile,
      hostHomeModules ? [],
      homeOverlays ? [],
    }: let
      user = users.${userName};
    in
      sharedHomeModules
      ++ [user.module]
      ++ homeProfiles.${homeProfile}
      ++ hostHomeModules
      ++ resolveHomeOverlays homeOverlays;

    # ── Builder: NixOS Home Manager module ───────────────────────────
    mkHomeModule = {
      userName,
      homeProfile,
      hostHomeModules ? [],
      homeOverlays ? [],
    }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.extraSpecialArgs = {inherit inputs;};
      home-manager.users.${userName} = {
        imports = mkHomeImports {
          inherit userName homeProfile hostHomeModules homeOverlays;
        };
      };
    };

    # ── Builder: NixOS output ────────────────────────────────────────
    mkOutput = {
      hostName,
      userName,
      systemProfile,
      homeProfile,
      homeOverlays ? [],
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
              inherit userName homeProfile homeOverlays;
              hostHomeModules = host.hostHomeModules or [];
            })
          ];
      };

    # ── Builder: nix-darwin output ───────────────────────────────────
    mkDarwinOutput = {
      userName,
      homeProfile,
      system,
      homeOverlays ? [],
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
            home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.${userName} = {
              imports = mkHomeImports {
                inherit userName homeProfile homeOverlays;
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
      homeOverlays ? [],
    }: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules =
          mkHomeImports {
            inherit userName homeProfile homeOverlays;
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
        homeOverlays = ["cli-extras" "ai-cli-all" "ai-ollama-rocm"];
      };

      boreal-tty-cyberdeck = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli-cyberdeck";
        homeOverlays = ["cli-extras" "ai-cli-all" "ai-ollama-rocm"];
      };

      boreal = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "sway";
        homeProfile = "sway";
        homeOverlays = ["cli-extras" "boreal-gui" "boreal-desktop"];
      };

      boreal-gaming = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "sway-gaming";
        homeProfile = "sway-gaming";
        homeOverlays = ["cli-extras" "boreal-gui" "boreal-desktop"];
      };

      boreal-gamescope = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "gamescope";
        homeProfile = "gamescope";
        homeOverlays = [];
      };

      boreal-niri = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "niri";
        homeProfile = "niri";
        homeOverlays = ["cli-extras" "boreal-gui"];
      };

      boreal-hypr = {
        hostName = "boreal";
        userName = "gars";
        systemProfile = "hyprland";
        homeProfile = "hyprland";
        homeOverlays = ["cli-extras" "boreal-gui"];
      };
    };

    rpi4OutputDefs = {
      rpi4-tty = {
        hostName = "rpi4";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli";
        homeOverlays = [];
      };

      rpi4-sway = {
        hostName = "rpi4";
        userName = "gars";
        systemProfile = "sway-arm";
        homeProfile = "sway-arm";
        homeOverlays = [];
      };

      rpi4-sway-full = {
        hostName = "rpi4";
        userName = "gars";
        systemProfile = "sway-arm";
        homeProfile = "sway-arm-full";
        homeOverlays = [];
      };

      rpi4-tty-cyberdeck = {
        hostName = "rpi4";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli-cyberdeck";
        homeOverlays = [];
      };
    };

    otherOutputDefs = {
      nixos-vm = {
        hostName = "nixos-vm";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli";
        homeOverlays = [];
      };

      cyberdeck-tty = {
        hostName = "cyberdeck";
        userName = "gars";
        systemProfile = "tty";
        homeProfile = "cli";
        homeOverlays = [];
      };
    };

    nixosOutputDefs = borealOutputDefs // rpi4OutputDefs // otherOutputDefs;

    # ── nix-darwin output definitions ────────────────────────────────
    darwinOutputDefs = {
      macbook = {
        userName = "htmlgxn";
        homeProfile = "cli";
        system = "aarch64-darwin";
        homeOverlays = ["ai-cli-all"];
      };
    };

    # ── Standalone Home Manager output definitions ───────────────────
    homeOutputDefs = {
      fedora-arm = {
        userName = "htmlgxn";
        homeProfile = "cli";
        system = "aarch64-linux";
        homeOverlays = [];
      };
    };
  in {
    nixosConfigurations = lib.mapAttrs (_: cfg: mkOutput cfg) nixosOutputDefs;
    darwinConfigurations = lib.mapAttrs (_: cfg: mkDarwinOutput cfg) darwinOutputDefs;
    homeConfigurations = lib.mapAttrs (_: cfg: mkHomeOutput cfg) homeOutputDefs;
  };
}
