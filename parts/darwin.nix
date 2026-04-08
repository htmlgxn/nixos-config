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

  darwinOutputDefs = {
    macbook = {
      userName = "htmlgxn";
      homeProfile = "gui";
      system = "aarch64-darwin";
      hostHomeModules = [(self + /hosts/macbook/home.nix)];
      homeOverlays = ["ai"];
    };
  };
in {
  flake.darwinConfigurations = builtins.mapAttrs (_: mkDarwinOutput) darwinOutputDefs;
}
