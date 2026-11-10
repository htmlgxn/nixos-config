# parts/apps.nix
#
# Flake app outputs.
{self, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    # Brave Nightly only ships Linux x86_64 builds for the boreal overlay.
    apps = lib.optionalAttrs (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
      update-brave-nightly = {
        type = "app";
        program = lib.getExe (pkgs.callPackage (self + /scripts/update-brave-nightly.nix) {});
        meta.description = "Bump overlays/brave-nightly.nix to the latest Brave Nightly release";
      };
    };
  };
}
