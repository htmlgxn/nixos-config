# parts/darwin.nix
#
# nix-darwin output definitions.
# Each entry selects a darwin host (darwinHosts in parts/lib.nix), user,
# home profile, and optional home overlay groups.
{
  flakeLib,
  self,
  ...
}: let
  inherit (flakeLib) mkDarwinOutput;

  kittyOverlay = import (self + /overlays/kitty-launchservices.nix);

  darwinOutputDefs = {
    macbook = {
      hostName = "macbook";
      userName = "htmlgxn";
      homeProfile = "gui";
      homeOverlays = ["ai"];
      nixpkgsOverlays = [kittyOverlay];
    };
  };
in {
  flake.darwinConfigurations = builtins.mapAttrs (_: mkDarwinOutput) darwinOutputDefs;
}
