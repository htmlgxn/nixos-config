# parts/apps.nix
#
# Flake app outputs.
{
  inputs,
  self,
  ...
}: let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  flake.apps.x86_64-linux.update-brave-nightly = {
    type = "app";
    program = "${pkgs.writeShellScriptBin "update-brave-nightly"
      (builtins.readFile (self + /scripts/update-brave-nightly.sh))}/bin/update-brave-nightly";
  };
}
