# parts/home.nix
#
# Standalone Home Manager output definitions.
# Each entry selects a user, home profile, target system,
# and optional home overlay groups.
{
  flakeLib,
  self,
  ...
}: let
  inherit (flakeLib) mkHomeOutput;

  homeOutputDefs = {
    fedora-mac = {
      userName = "htmlgxn";
      homeProfile = "cli";
      system = "aarch64-linux";
      homeOverlays = [];
    };

    jetson = {
      userName = "gars";
      homeProfile = "cli";
      system = "aarch64-linux";
      homeOverlays = [];
      hostHomeModules = [(self + /hosts/jetson/home.nix)];
    };
  };
in {
  flake.homeConfigurations = builtins.mapAttrs (_: mkHomeOutput) homeOutputDefs;
}
