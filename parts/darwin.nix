# parts/darwin.nix
#
# nix-darwin output definitions.
# Each entry selects a user, home profile, target system,
# and optional home overlay groups.
{
  flakeLib,
  self,
  ...
}: let
  inherit (flakeLib) mkDarwinOutput;

  kittyOverlay = import (self + /overlays/kitty-launchservices.nix);

  darwinOutputDefs = {
    macbook = {
      userName = "htmlgxn";
      homeProfile = "gui";
      system = "aarch64-darwin";
      hostHomeModules = [(self + /hosts/macbook/home.nix)];
      homeOverlays = ["ai"];
      nixpkgsOverlays = [kittyOverlay];
    };
  };
in {
  flake.darwinConfigurations = builtins.mapAttrs (_: mkDarwinOutput) darwinOutputDefs;
}
