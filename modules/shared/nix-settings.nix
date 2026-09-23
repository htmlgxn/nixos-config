# Shared Nix daemon config for NixOS and nix-darwin outputs: Lix from nixpkgs
# (see overlays/lix.nix), flakes, and the binary caches used across hosts.
{pkgs, ...}: {
  nix = {
    package = pkgs.lixPackageSets.stable.lix;

    # Hard-link identical store files on a schedule (safer than auto-optimise-store).
    optimise.automatic = true;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
