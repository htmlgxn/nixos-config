# parts/darwin.nix
#
# nix-darwin output definitions.
# Each entry selects a user, home profile, target system,
# and optional home overlay groups.
{flakeLib, ...}: let
  inherit (flakeLib) mkDarwinOutput;

  darwinOutputDefs = {
    macbook = {
      userName = "htmlgxn";
      homeProfile = "cli";
      system = "aarch64-darwin";
      homeOverlays = ["ai-cli-all"];
    };
  };
in {
  flake.darwinConfigurations = builtins.mapAttrs (_: mkDarwinOutput) darwinOutputDefs;
}
