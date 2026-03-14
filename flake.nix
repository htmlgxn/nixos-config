#
# ~/nixos-config/flake.nix
#

{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url   = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    hmBase = {
      home-manager.useGlobalPkgs    = true;
      home-manager.useUserPackages  = true;
      home-manager.users.gars = { imports = [
        ./home/gars/home.nix
        ./modules/home/cli.nix
      ]; };
    };

    # GUI: CLI + shared GUI packages (all compositors)
    hmGui = {
      home-manager.useGlobalPkgs    = true;
      home-manager.useUserPackages  = true;
      home-manager.users.gars = { imports = [
        ./home/gars/home.nix
        ./modules/home/cli.nix
        ./modules/home/gui-base.nix
        ./modules/home/sway.nix
      ]; };
    };
  in {
    nixosConfigurations = {

      # ── Sway — production ──────────────────────────────────────────────
      boreal = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ({ ... }: { nixpkgs.config.allowUnfree = true; })
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/sway.nix
          home-manager.nixosModules.home-manager
          #({ ... }: { imports = [ ./modules/home/sway.nix ]; })
          hmGui
        ];
      };

      # ── Niri ───────────────────────────────────────────────────────────
      boreal-niri = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ({ ... }: { nixpkgs.config.allowUnfree = true; })
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/niri.nix
          home-manager.nixosModules.home-manager
          #({ ... }: { imports = [ ./modules/home/niri.nix ]; })
          #hmGui
        ];
      };

      # ── VM ──────────────────────────────────────────────────────────────
      nixos-vm = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm/configuration.nix
          ./modules/system/cli.nix
          home-manager.nixosModules.home-manager
          hmBase
        ];
      };
    };
  };
}
