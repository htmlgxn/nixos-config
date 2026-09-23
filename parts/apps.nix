# parts/apps.nix
#
# Flake app outputs.
{
  inputs,
  self,
  ...
}: let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  updateBraveNightly = pkgs.callPackage (self + /scripts/update-brave-nightly.nix) {};
in {
  flake.apps.x86_64-linux.update-brave-nightly = {
    type = "app";
    program = "${updateBraveNightly}/bin/update-brave-nightly";
  };
}
