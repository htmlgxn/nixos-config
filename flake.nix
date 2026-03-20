# See docs/architecture.md and docs/workflows.md for repo structure and change workflows.
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
      ./modules/home/containers.nix
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
          ./modules/system/containers.nix
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
      cli = [
        ./modules/home/nvim-theme.nix
      ];
      cli-cyberdeck = [
        ./modules/home/cli-cyberdeck.nix
        ./modules/home/nvim-theme.nix
      ];
      sway = [
        ./modules/home/gui-base.nix
        ./modules/home/sway.nix
        ./modules/home/flatpak.nix
        ./modules/home/nvim-theme.nix
      ];
      sway-gaming = [
        ./modules/home/gui-base.nix
        ./modules/home/sway.nix
        ./modules/home/flatpak.nix
        ./modules/home/gaming.nix
        ./modules/home/nvim-theme.nix
      ];
      niri = [
        ./modules/home/gui-base.nix
        ./modules/home/niri.nix
        ./modules/home/flatpak.nix
        ./modules/home/nvim-theme.nix
      ];
      hyprland = [
        ./modules/home/gui-base.nix
        ./modules/home/hyprland.nix
        ./modules/home/flatpak.nix
        ./modules/home/nvim-theme.nix
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
