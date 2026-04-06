# parts/home.nix
#
# Standalone Home Manager output definitions.
# Each entry selects a user, home profile, target system,
# and optional home overlay groups.
{flakeLib, ...}: let
  inherit (flakeLib) mkHomeOutput;

  homeOutputDefs = {
    fedora-arm = {
      userName = "htmlgxn";
      homeProfile = "cli";
      system = "aarch64-linux";
      homeOverlays = [];
    };
  };
in {
  flake.homeConfigurations = builtins.mapAttrs (_: cfg: mkHomeOutput cfg) homeOutputDefs;
}
