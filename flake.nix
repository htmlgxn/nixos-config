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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    hmCommonImports = [
      ./home/gars/home.nix
      ./modules/home/cli.nix
    ];

    mkHm = extraImports: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.gars = {
        imports = hmCommonImports ++ extraImports;
      };
    };

    hmBase = mkHm [];

    # GUI: CLI + shared GUI base + Sway specific
    hmSway = mkHm [
      ./modules/home/gui-base.nix
      ./modules/home/sway.nix
    ];

    # GUI: CLI + shared GUI base + Niri specific
    hmNiri = mkHm [
      ./modules/home/gui-base.nix
      ./modules/home/niri.nix
    ];
  in {
    nixosConfigurations = {
      # ── Sway — production ──────────────────────────────────────────────
      boreal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {nixpkgs.config.allowUnfree = true;})
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/sway.nix
          home-manager.nixosModules.home-manager
          hmSway
        ];
      };

      # ── Niri ───────────────────────────────────────────────────────────
      boreal-niri = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({...}: {nixpkgs.config.allowUnfree = true;})
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/niri.nix
          home-manager.nixosModules.home-manager
          hmNiri
        ];
      };

      # ── VM ──────────────────────────────────────────────────────────────
      nixos-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm/configuration.nix
          ./modules/system/cli.nix
          home-manager.nixosModules.home-manager
          hmBase
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
      #   ];
      # };
    };
  };
}
