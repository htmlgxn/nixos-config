#
# ~/nixos-config/modules/home/packages/go/default.nix
#
# =============================================================================
# GO TOOLCHAIN & CUSTOM TOOLS
# =============================================================================
# Go programming language toolchain and custom Go-based tools.
#
# Includes:
#   - Go compiler and toolchain
#   - Custom tools defined in packages.nix (built from GitHub sources)
#
# TO ADD GO TOOLS:
#
# Option 1 - From nixpkgs:
#   home.packages = with pkgs; [ delve golangci-lint ];
#
# Option 2 - Custom from GitHub (using packages.nix):
#   1. Add to packages.nix:
#      mytool = {
#        pname = "mytool";
#        version = "0.1.0";
#        owner = "username";
#        repo = "mytool";
#        rev = "v0.1.0";
#        hash = "sha256-...";
#        vendorHash = "sha256-...";
#      };
#   2. Rebuild to get the hash (it will fail with expected hash)
#   3. Update with correct hash
#
# TO FIND VENDOR HASH:
#   Run `nix build` - it will fail and show the expected vendorHash.
# =============================================================================
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
