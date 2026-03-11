{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    hmConfig = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.htmlgxn = import ./home/htmlgxn/home.nix;
    };

    hmConfigGui = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.htmlgxn = { imports = [ 
        ./home/htmlgxn/home.nix 
        ./modules/home/gui.nix 
      ]; };
    };
  in {
    nixosConfigurations = {

      nixos-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm/configuration.nix
          home-manager.nixosModules.home-manager
	  hmConfig
        ];
      };

      nixos-vm-gui = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm/configuration.nix
	  ./modules/system/sway.nix
          home-manager.nixosModules.home-manager
	  hmConfigGui
        ];
      };
    };
  };
}
