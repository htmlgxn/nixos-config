# Go toolchain plus custom Go packages from `packages.nix`.
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
      doCheck = false;
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
