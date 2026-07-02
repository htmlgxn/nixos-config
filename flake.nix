# See docs/architecture.md and docs/workflows.md for repo structure and change workflows.
{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # Intentionally NOT following nixpkgs: nixvim's release tracks the latest
      # unstable (26.11) while our nixpkgs pin lags (26.05). Letting nixvim use
      # its own matching nixpkgs pin avoids the version-mismatch warnings.
    };

    nix-yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jetpack-nixos = {
      url = "github:anduril/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane.url = "github:ipetkov/crane";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bookokrat.url = "github:bugzmanov/bookokrat/7cf047d3b238c3d8be88e8a2fdc58890d86a1011";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      # We consume this via its `lixFromNixpkgs` module variant (see parts/lib.nix),
      # so lix itself comes prebuilt from nixpkgs (cache.nixos.org) and is never
      # compiled from source — avoiding the crates.io-403 vendoring failure.
      #
      # Pinned to the last 2.95-compatible commit (parent of the 2.96 version bump);
      # its version.json selects nixpkgs' lixPackageSets.lix_2_95. Bump this commit
      # only when nixpkgs' lix major moves.
      url = "https://git.lix.systems/lix-project/nixos-module/archive/1688100bba140492658d597f6b307c327f35c780.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      # The lix source input is unused by lixFromNixpkgs; pin it to a release tag
      # (not the drifting `main`) so `nix flake update` stays stable.
      inputs.lix.url = "https://git.lix.systems/lix-project/lix/archive/2.95.3.tar.gz";
      inputs.lix.flake = false;
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = [
        ./parts/lib.nix
        ./parts/nixos.nix
        ./parts/darwin.nix
        ./parts/home.nix
        ./parts/apps.nix
        ./parts/treefmt.nix
      ];
    };
}
