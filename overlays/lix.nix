#
# ~/nixos-config/overlays/lix.nix
#
# Lix from nixpkgs, as recommended by lix.systems for released versions
# (https://lix.systems/add-to-config/). `nix.package` is set in
# modules/shared/nix-settings.nix; this rewires the Nix-linked tools to the
# same Lix. Applied to every output by parts/lib.nix (sharedOverlays).
#
_final: prev: {
  inherit
    (prev.lixPackageSets.stable)
    nixpkgs-review
    nix-eval-jobs
    nix-fast-build
    colmena
    ;
}
