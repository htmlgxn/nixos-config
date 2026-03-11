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
    jetpack-nixos = {
      url = "github:anduril/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, jetpack-nixos, ... }:
  let
    hmConfig = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.gars = { imports = [
        ./home/gars/home.nix
        ./modules/home/cli.nix  # CLI tools
      ]; };
    };

    hmConfigGui = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.gars = { imports = [ 
        ./home/gars/home.nix 
        ./modules/home/cli.nix  # CLI tools
        ./modules/home/gui.nix 
      ]; };
    };
  in {
    nixosConfigurations = {

      nixos-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm/configuration.nix
	  ./modules/system/cli.nix
          home-manager.nixosModules.home-manager
	  hmConfig
        ];
      };

      cyberdeck = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
	  jetpack-nixos.nixosModules.default
          ./hosts/cyberdeck/configuration.nix
	  ./modules/system/cli.nix
          home-manager.nixosModules.home-manager
	  hmConfig
        ];
      };

      nixos-vm-gui = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm/configuration.nix
	  ./modules/system/cli.nix
	  ./modules/system/sway.nix
          home-manager.nixosModules.home-manager
	  hmConfigGui
        ];
      };
    };
  };
}
