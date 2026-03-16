#
# ~/nixos-config/modules/home/packages/go/default.nix
#
{pkgs, ...}: let
  packages = import ./packages.nix;

  mkGoPackage = {
    pname,
    version,
    owner,
    repo,
    rev,
    hash,
    vendorHash,
    subPackages ? [],
    modVendor ? false,
    ...
  }:
    pkgs.buildGoModule {
      inherit pname version subPackages vendorHash modVendor;
      src = pkgs.fetchFromGitHub {inherit owner repo rev hash;};
    };

  builtPkgs =
    builtins.mapAttrs
    (pname: attrs: mkGoPackage ({inherit pname;} // attrs))
    packages;
in {
  home.packages = with pkgs;
    [
      # ── Toolchain ────────────────────────────────────────────────────
      go

      # ── Custom Tools ────────────────────────────────────────────────
    ]
    ++ builtins.attrValues builtPkgs;
}
