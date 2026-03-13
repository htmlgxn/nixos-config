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

    # COSMIC — binary cache avoids compiling ~16 GB of Rust locally
    nixos-cosmic = {
      url   = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-cosmic, ... }:
  let

    # ── Cachix binary cache for COSMIC ──────────────────────────────────
    cosmicCache = {
      nix.settings = {
        substituters      = [ "https://cosmic.cachix.org/" ];
        trusted-public-keys = [
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        ];
      };
    };

    # ── Home-manager configurations ──────────────────────────────────────
    # Base: CLI only (headless / VM)
    hmBase = {
      home-manager.useGlobalPkgs    = true;
      home-manager.useUserPackages  = true;
      home-manager.users.gars = { imports = [
        ./home/gars/home.nix
        ./modules/home/cli.nix
      ]; };
    };

    # Sway: CLI + GUI with sway dotfile symlinks
    hmSway = {
      home-manager.useGlobalPkgs    = true;
      home-manager.useUserPackages  = true;
      home-manager.users.gars = { imports = [
        ./home/gars/home.nix
        ./modules/home/cli.nix
        ./modules/home/gui.nix       # includes sway dotfile symlinks
      ]; };
    };

    # GUI base: CLI + GUI packages, no compositor-specific dotfiles
    # Used for COSMIC, Hyprland, Niri, River, Wayfire, LabWC
    hmGui = {
      home-manager.useGlobalPkgs    = true;
      home-manager.useUserPackages  = true;
      home-manager.users.gars = { imports = [
        ./home/gars/home.nix
        ./modules/home/cli.nix
        ./modules/home/gui-base.nix  # no sway dotlinks
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
          hmSway
        ];
      };

      # ── COSMIC ─────────────────────────────────────────────────────────
      boreal-cosmic = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          cosmicCache
          nixos-cosmic.nixosModules.default
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/cosmic.nix
          home-manager.nixosModules.home-manager
          hmGui
        ];
      };

      # ── Hyprland ───────────────────────────────────────────────────────
      boreal-hyprland = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/hyprland.nix
          home-manager.nixosModules.home-manager
          hmGui
        ];
      };

      # ── Niri ───────────────────────────────────────────────────────────
      boreal-niri = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/niri.nix
          home-manager.nixosModules.home-manager
          hmGui
        ];
      };

      # ── River ──────────────────────────────────────────────────────────
      boreal-river = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/river.nix
          home-manager.nixosModules.home-manager
          hmGui
        ];
      };

      # ── Wayfire ────────────────────────────────────────────────────────
      boreal-wayfire = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/wayfire.nix
          home-manager.nixosModules.home-manager
          hmGui
        ];
      };

      # ── LabWC ──────────────────────────────────────────────────────────
      boreal-labwc = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./hosts/boreal/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/labwc.nix
          home-manager.nixosModules.home-manager
          hmGui
        ];
      };

      # ── VMs ────────────────────────────────────────────────────────────
      nixos-vm = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm/configuration.nix
          ./modules/system/cli.nix
          home-manager.nixosModules.home-manager
          hmBase
        ];
      };

      nixos-vm-gui = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./hosts/nixos-vm/configuration.nix
          ./modules/system/cli.nix
          ./modules/system/sway.nix
          home-manager.nixosModules.home-manager
          hmSway
        ];
      };
    };
  };
}
