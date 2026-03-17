#
# ~/nixos-config/flake.nix
#
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
    hmCommonImports = [
      ./home/gars/home.nix
      ./modules/home/cli.nix
      # Language toolchains & custom packages
      ./modules/home/packages
    ];

    mkHm = extraImports: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs;};
      home-manager.users.gars = {
        imports = hmCommonImports ++ extraImports;
      };
    };

    hmBase = mkHm [];
    hmExtras = mkHm [
      ./modules/home/cli-extras.nix
    ];

    # GUI: CLI + shared GUI base + Sway specific
    hmSway = mkHm [
      ./modules/home/gui-base.nix
      ./modules/home/sway.nix
      ./modules/home/flatpak.nix
    ];

    # GUI: CLI + shared GUI base + Niri specific
    hmNiri = mkHm [
      ./modules/home/gui-base.nix
      ./modules/home/niri.nix
      ./modules/home/flatpak.nix
    ];

    # GUI: CLI + shared GUI base + Hyprland specific
    hmHyprland = mkHm [
      ./modules/home/gui-base.nix
      ./modules/home/hyprland.nix
      ./modules/home/flatpak.nix
    ];
  in {
    nixosConfigurations = {
      # ── Sway — production ──────────────────────────────────────────────
      boreal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/sway.nix
          ./modules/system/jellyfin.nix
          ./modules/system/flatpak.nix
          home-manager.nixosModules.home-manager
          hmSway
          hmExtras
        ];
      };

      # ── TTY only — boreal ──────────────────────────────────────────────
      boreal-tty = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/jellyfin.nix
          home-manager.nixosModules.home-manager
          hmBase
          hmExtras
        ];
      };

      # ── Niri ───────────────────────────────────────────────────────────
      boreal-niri = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/niri.nix
          ./modules/system/flatpak.nix
          ./modules/system/jellyfin.nix
          home-manager.nixosModules.home-manager
          hmNiri
          # hmExtras (disabled: niri build not yet stable)
        ];
      };

      # ── Hyprland ───────────────────────────────────────────────────────
      boreal-hypr = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/hyprland.nix
          ./modules/system/flatpak.nix
          ./modules/system/jellyfin.nix
          home-manager.nixosModules.home-manager
          hmHyprland
          hmExtras
        ];
      };

      # ── VM ──────────────────────────────────────────────────────────────
      nixos-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/nixos-vm/configuration.nix
          ./modules/system/cli.nix
          home-manager.nixosModules.home-manager
          hmBase
          # hmExtras (disabled: VM minimal config)
        ];
      };

      # ── Cyberdeck (future) ─────────────────────────────────────────────
      # cyberdeck = nixpkgs.lib.nixosSystem {
      #   system  = "aarch64-linux";
      #   modules = [
      #     ./hosts/cyberdeck/configuration.nix
      #     ./modules/system/cli.nix
      #     home-manager.nixosModules.home-manager
      #     hmBase
      #     # hmExtras: enable only after the first successful build.
      #   ];
      # };
    };
  };
}
